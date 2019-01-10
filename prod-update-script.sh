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
# ./prod-update-script.sh

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

echo "## ENTER STACK NAME TAG (as prod) ##"

read -p "Enter stack name tag: " tag


### Removing & Deploying Control-Plane Service ############

echo "## REMOVING CONTROL-PLANE SERVICE ##"
#docker service rm prod_fx-control-plane
docker service rm "$tag"_fx-control-plane
sleep 5

echo "## DEPLOYING CONTROL-PLANE SERVICE ##"
#docker stack deploy -c docker-compose-control-plane.yaml prod
docker stack deploy -c docker-compose-control-plane.yaml "$tag"
sleep 60

### Removing & Deploying dependent services ############
echo "## REMOVING DEPENDENT SERVICES ##"
#docker service rm prod_fx-mail-bot prod_fx-vc-git-skill-bot prod_fx-it-github-skill-bot prod_fx-it-jira-skill-bot prod_fx-cloud-aws-skill-bot prod_fx-notification-slack-skill-bot
docker service rm "$tag"_fx-mail-bot "$tag"_fx-vc-git-skill-bot "$tag"_fx-it-github-skill-bot "$tag"_fx-it-jira-skill-bot "$tag"_fx-cloud-aws-skill-bot "$tag"_fx-notification-slack-skill-bot
sleep 10

echo "## DEPLOYING DEPENDENT SERVICES ##"
#docker stack deploy -c docker-compose-dependents.yaml prod
docker stack deploy -c docker-compose-dependents.yaml "$tag"
sleep 30

### Removing & Deploying Haproxy ############
 
echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm prod_fx-haproxy
docker service rm "$tag"_fx-haproxy
sleep 5

echo "## DEPLOYING HAPROXY SERVICE ##"
#docker stack deploy -c docker-compose-proxy.yaml  prod
docker stack deploy -c docker-compose-proxy.yaml  "$tag"

sleep 10

docker service ls
sleep 5
echo "Services Successfully Refreshed"
