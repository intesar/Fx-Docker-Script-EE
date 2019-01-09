#!/bin/bash -x
# FXLABS production services update-script https://fxlabs.io/
# 2019-01-09

# Installer folder should have the following files
# 1.	.env
# 2.	docker-compose-data.yaml
# 3.	docker-compose-control-plane.yaml
# 4.	docker-compose-dependents.yaml
# 5.	fx-security-enterprise-proxy.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh
# 8.    fx-security-enterprise-update.sh

# sudo chmod 755 -R /Fx-Docker-Script
# cd /path-of-these-files eg. cd /Fx-Docker-Script 
# sudo su
# "run below command from path of the above files
# ./fx-prod-update-script.sh

read -p "Enter tag: " tag

############ Pulling latest build fxlabs images ############

echo "Pulling latest build fxlabs images"

#3.	Pull fx-security-enterprise docker images (based on the tag input)
docker pull fxlabs/control-plane:"$tag"
docker pull fxlabs/vc-git-skill-bot:"$tag"
##docker pull fxlabs/bot:"$tag"
docker pull fxlabs/notification-email-skill-bot:"$tag"
docker pull fxlabs/issue-tracker-github-skill-bot:"$tag"
docker pull fxlabs/issue-tracker-jira-skill-bot:"$tag"
docker pull fxlabs/issue-tracker-fx-skill-bot:"$tag"
docker pull fxlabs/cloud-aws-skill-bot:"$tag"
docker pull fxlabs/notification-slack-skill-bot:"$tag"


source .env
export $(cut -d= -f1 .env)

### Removing & Deploying Control-Plane Service ############

echo "Removing Control-Plane Service"
docker service rm prod_fx-control-plane
sleep 5

echo "Deploying Control-Plane Service"
docker stack deploy -c docker-compose-control-plane.yaml prod
sleep 60

### Removing & Deploying dependent services ############

echo "Removing Dependent Services"
docker service rm prod_fx-mail-bot prod_fx-vc-git-skill-bot prod_fx-it-github-skill-bot prod_fx-it-jira-skill-bot prod_fx-cloud-aws-skill-bot prod_fx-notification-slack-skill-bot
sleep 10

echo "Deploying Dependent Services"
docker stack deploy -c docker-compose-dependents.yaml prod
sleep 30

### Removing & Deploying Haproxy ############
# 
echo "Removing Haproxy Service"
docker service rm prod_fx-haproxy
sleep 5

echo "Deploying Haproxy Service"
docker stack deploy -c docker-compose-proxy.yaml  prod
sleep 10

docker service ls
sleep 5
echo "Services Successfully Refreshed"
