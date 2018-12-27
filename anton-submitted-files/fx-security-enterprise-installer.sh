#!/bin/bash -x
# FX security enterprise installer script https://fxlabs.io/
# 20181224

# Installer folder should have the following files
# 1.	.env
# 2.	fx-security-enterprise-data.yaml
# 3.	fx-security-enterprise-control-plane.yaml
# 4.	fx-security-enterprise-dependents.yaml
# 5.	fx-security-enterprise-haproxy.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh

read -p "Enter tag: " tag

#1.	Install docker (latest)
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

#2.	Activate docker-swarm mode
sudo docker swarm init

#3.	Pull fx-security-enterprise docker images (based on the tag input)
docker pull fxlabs/control-plane-ee:"$tag"
docker pull fxlabs/vc-git-skill-bot-ee:"$tag"
docker pull fxlabs/bot-ee:"$tag"
docker pull fxlabs/notification-email-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-github-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-jira-skill-bot-ee:"$tag"

#4.	Create folder for docker volumes. Optionally, user can mount external drives at these locations.
mkdir -p /fx-security-enterprise/postgres/data
mkdir -p /fx-security-enterprise/elasticsearch/data
mkdir -p /fx-security-enterprise/rabbitmq/data
mkdir -p /fx-security-enterprise/haproxy

#5.	Self-signed certificate creation.
# All the cert files (fxcloud.key, fxcloud.crt, fxcloud.pem, and haproxy.cfg) should be moved to /fx-security-enterprise/haproxy folder
SSL_DIR="/fx-security-enterprise/haproxy"
cp haproxy.cfg $SSL_DIR

# Let user customize certification creation with sensible defaults
echo "Please enter info to generate SSL Private Key, CSR and Certificate"
read -p "Enter Passphrase for private key: " Passphrase
read -p "Enter Common Name (The Common Name is the Host + Domain Name. It looks like "www.company.com" or "company.com"): " CommonName
read -p "Enter Country (Use the two-letter code without punctuation for country, for example: US or CA): " Country
read -p "Enter City or Locality (The Locality field is the city or town name, for example: Berkeley): " City
read -p "Enter State or Province (Spell out the state completely; do not abbreviate the state or province name, for example: California): " State
read -p "Enter Organization: " Organization
read -p "Enter Organizational Unit (This field is the name of the department or organization unit making the request): "  OrganizationalUnit

# Set our CSR variables
SUBJ="
CN="$CommonName"
C="$Country"
L="$City"
ST="$State"
O="$Organization"
OU="$OrganizationalUnit"
"

# Create our SSL directory in case it doesn't exist
sudo mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "$SSL_DIR/fxcloud.key" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/fxcloud.key" -out "$SSL_DIR/fxcloud.csr" -passin pass:"$Passphrase"
sudo openssl x509 -req -days 365 -in "$SSL_DIR/fxcloud.csr" -signkey "$SSL_DIR/fxcloud.key" -out "$SSL_DIR/fxcloud.crt"

#6.	Run
sysctl -w vm.max_map_count=262144
source .env
export $(cut -d= -f1 .env)

# RabbitMQ
# Generate and set random password for “POSTGRES_PASSWORD” in .env
POSTGRES_PASSWORD="$(openssl rand -base64 12)"
sed -i "s|POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$POSTGRES_PASSWORD|g" .env

# Generate and set random password for “RABBITMQ_DEFAULT_PASS” in .env
RABBITMQ_DEFAULT_PASS="$(openssl rand -base64 12)"
sed -i "s|RABBITMQ_DEFAULT_PASS=.*|RABBITMQ_DEFAULT_PASS=$RABBITMQ_DEFAULT_PASS|g" .env

# Generate and set random password for “RABBITMQ_DEFAULT_PASS” in .env
RABBITMQ_AGENT_PASS="$(openssl rand -base64 12)"
sed -i "s|RABBITMQ_AGENT_PASS=.*|RABBITMQ_AGENT_PASS=$RABBITMQ_AGENT_PASS|g" .env

# Run Docker stack deploy
docker stack deploy -c fx-security-enterprise-data.yaml prod
sleep 30

# RabbitMQ Scanbot password (These commands need to executed on RabbitMQ container)
docker exec $(docker ps -q -f name=fx-rabbitmq) rabbitmqctl add_user fx_bot_user ${RABBITMQ_AGENT_PASS}
docker exec $(docker ps -q -f name=fx-rabbitmq) rabbitmqctl set_permissions -p fx fx_bot_user "" ".*" ".*"
docker stack deploy -c fx-security-enterprise-control-plane.yaml prod
sleep 60
docker stack deploy -c fx-security-enterprise-dependents.yaml prod
docker stack deploy -c fx-security-enterprise-haproxy.yaml prod

