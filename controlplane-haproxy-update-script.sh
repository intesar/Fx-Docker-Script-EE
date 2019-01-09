#!/bin/bash -x
# FXLABS UAT services update-script https://fxlabs.io/
# 2019-01-09
#

# Installer folder should have the following files
# 1.	.env
# 2.	docker-compose-data.yaml
# 3.	docker-compose-control-plane.yaml
# 4.	docker-compose-dependents.yaml
# 5.	fx-security-enterprise-proxy.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh
# 8.    fx-security-enterprise-update.sh

## sudo chmod 755 -R /Fx-Docker-Script/
## cd /path-of-these-files eg. cd /Fx-Docker-Script 
## sudo su
## "run below command from path of the above files
## ./controlplane-haproxy-update-script.sh

read -p "Enter tag: " tag


##cd /opt/fx/uat/Fx-Docker-Script/
source .env
export $(cut -d= -f1 .env)

############ Pulling latest build fxlabs images ############

echo "Pulling latest build fxlabs/control-plane image"


# pull images on other nodes.
docker pull fxlabs/control-plane:"$tag"




### Removing & Deploying Control-Plane Service ############

echo "Removing Control-Plane Service"
docker service rm uat1_fx-control-plane

sleep 5

echo "Deploying Control-Plane Service"
docker stack deploy -c docker-compose-control-plane.yaml uat1
sleep 30



### Removing & Deploying Haproxy ############
 
echo "Removing Haproxy Service"
docker service rm uat1_fx-haproxy
sleep 5

echo "Deploying Haproxy Service"
docker stack deploy -c docker-compose-proxy.yaml uat1
sleep 10

# remove unused images
#docker rmi $(docker images -a -q)

docker service ls
sleep 5
docker ps
sleep 4
echo "Successfully refreshed UAT Environment."
