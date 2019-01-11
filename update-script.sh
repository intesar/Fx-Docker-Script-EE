﻿#!/bin/bash -x
# FXLABS UAT services update-script https://fxlabs.io/
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

## sudo chmod 755 -R /Fx-Docker-Script
## cd /path-of-these-files eg. cd /Fx-Docker-Script 
## sudo su
## "run below command from path of the above files
## ./fx-uat-update-script.sh

#read -p "Enter tag: " tag


##cd /opt/fx/uat/Fx-Docker-Script/
source .env
export $(cut -d= -f1 .env)

############ Pulling latest build fxlabs images ############

echo "## PULLING LATEST BUILD FXLABS IMAGES ##"


# pull images on other nodes.
docker pull fxlabs/control-plane:$1
docker pull fxlabs/vc-git-skill-bot:$1
docker pull fxlabs/bot:$1
docker pull fxlabs/notification-email-skill-bot:$1
docker pull fxlabs/issue-tracker-github-skill-bot:$1
docker pull fxlabs/issue-tracker-fx-skill-bot:$1
docker pull fxlabs/issue-tracker-jira-skill-bot:$1
docker pull fxlabs/cloud-aws-skill-bot:$1
docker pull fxlabs/notification-slack-skill-bot:$1

#echo "## ENTER STACK NAME TAG (as uat1) ##"

#read -p "Enter stack name tag: " tag



### Removing & Deploying Control-Plane Service ############

echo "## REMOVING CONTROL-PLANE SERVICE ##"
#docker service rm uat1_fx-control-plane
#docker service rm "$tag"_fx-control-plane
docker service rm $2_fx-control-plane

sleep 5

echo "## DEPLOYING CONTROL-PLANE SERVICE ##"
#docker stack deploy -c docker-compose-control-plane.yaml uat1
#docker stack deploy -c docker-compose-control-plane.yaml "$tag"
docker stack deploy -c docker-compose-control-plane.yaml $2
sleep 30

### Removing & Deploying dependent services ############

echo "## REMOVING DEPENDENT SERVICES ##"
#docker service rm uat1_fx-mail-bot uat1_fx-vc-git-skill-bot uat1_fx-it-github-skill-bot uat1_fx-it-fx-skill-bot uat1_fx-it-jira-skill-bot uat1_fx-cloud-aws-skill-bot uat1_fx-notification-slack-skill-bot
#docker service rm "$tag"_fx-mail-bot "$tag"_fx-vc-git-skill-bot "$tag"_fx-it-github-skill-bot "$tag"_fx-it-fx-skill-bot "$tag"_fx-it-jira-skill-bot "$tag"_fx-cloud-aws-skill-bot "$tag"_fx-notification-slack-skill-bot
docker service rm $2_fx-mail-bot $2_fx-vc-git-skill-bot $2_fx-it-github-skill-bot $2_fx-it-fx-skill-bot $2_fx-it-jira-skill-bot $2_fx-cloud-aws-skill-bot $2_fx-notification-slack-skill-bot
sleep 5

echo "## DEPLOYING DEPENDENT SERVICES ##"
#docker stack deploy -c docker-compose-dependents.yaml uat1
#docker stack deploy -c docker-compose-dependents.yaml "$tag"
docker stack deploy -c docker-compose-dependents.yaml $2
sleep 60

### Removing & Deploying Haproxy ############
 
echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm uat1_fx-haproxy
#docker service rm "$tag"_fx-haproxy
docker service rm $2_fx-haproxy
sleep 5

echo "## DEPLOYING HAPROXY SERVICE ##"
#docker stack deploy -c docker-compose-proxy.yaml uat1
#docker stack deploy -c docker-compose-proxy.yaml "$tag"
docker stack deploy -c docker-compose-proxy.yaml $2
sleep 10

# remove unused images
#docker rmi $(docker images -a -q)

docker service ls
sleep 5
docker ps
sleep 5
echo "Successfully refreshed" $2 "Environment."