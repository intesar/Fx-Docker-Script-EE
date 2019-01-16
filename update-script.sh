#!/bin/bash -x
# FXLABS UAT services update-script https://fxlabs.io/
# 2019-01-09

# Installer folder should have the following files
# 1.	.env
# 2.	docker-compose-data.yaml
# 3.	docker-compose-control-plane.yaml
# 4.	docker-compose-dependents.yaml
# 5.	docker-compose-proxy.yaml
# 6.	haproxy.cfg
# 8.    update-script.sh

## sudo chmod 744 -R /Fx-Docker-Script/update-script.sh
## cd /path-of-these-files eg. cd /Fx-Docker-Script 
## sudo su
## "run below command from path of the above files
## ./update-script.sh

#read -p "Enter tag: " tag

ImageTag=$1
StackName=$2
#### For UAt env=env & For PROD env=env-prod #########
env=$3


##cd /opt/fx/uat/Fx-Docker-Script/
source ."$env"
export $(cut -d= -f1 ."$env")

############ Pulling latest build fxlabs images ############

echo "## PULLING LATEST BUILD FXLABS IMAGES ##"


# pull images on other nodes.
docker pull fxlabs/control-plane:"$ImageTag"
docker pull fxlabs/vc-git-skill-bot:"$ImageTag"
docker pull fxlabs/bot:$ImageTag
docker pull fxlabs/notification-email-skill-bot:"$ImageTag"
docker pull fxlabs/issue-tracker-github-skill-bot:"$ImageTag"
docker pull fxlabs/issue-tracker-fx-skill-bot:"$ImageTag"
docker pull fxlabs/issue-tracker-jira-skill-bot:"$ImageTag"
docker pull fxlabs/cloud-aws-skill-bot:"$ImageTag"
docker pull fxlabs/notification-slack-skill-bot:"$ImageTag"

#echo "## ENTER STACK NAME TAG (as uat1) ##"

#read -p "Enter stack name tag: " tag



### Removing & Deploying Control-Plane Service ############

echo "## REMOVING CONTROL-PLANE SERVICE ##"
#docker service rm uat1_fx-control-plane
#docker service rm "$tag"_fx-control-plane
#docker service rm $2_fx-control-plane

docker service rm "$StackName"_fx-control-plane

sleep 5

echo "## DEPLOYING CONTROL-PLANE SERVICE ##"
#docker stack deploy -c docker-compose-control-plane.yaml uat1
#docker stack deploy -c docker-compose-control-plane.yaml "$tag"
docker stack deploy -c docker-compose-control-plane.yaml "$StackName"
sleep 30

### Removing & Deploying dependent services ############

echo "## REMOVING DEPENDENT SERVICES ##"
#docker service rm uat1_fx-mail-bot uat1_fx-vc-git-skill-bot uat1_fx-it-github-skill-bot uat1_fx-it-fx-skill-bot uat1_fx-it-jira-skill-bot uat1_fx-cloud-aws-skill-bot uat1_fx-notification-slack-skill-bot
#docker service rm "$tag"_fx-mail-bot "$tag"_fx-vc-git-skill-bot "$tag"_fx-it-github-skill-bot "$tag"_fx-it-fx-skill-bot "$tag"_fx-it-jira-skill-bot "$tag"_fx-cloud-aws-skill-bot "$tag"_fx-notification-slack-skill-bot
#docker service rm $2_fx-mail-bot $2_fx-vc-git-skill-bot $2_fx-it-github-skill-bot $2_fx-it-fx-skill-bot $2_fx-it-jira-skill-bot $2_fx-cloud-aws-skill-bot $2_fx-notification-slack-skill-bot

docker service rm "$StackName"_fx-mail-bot "$StackName"_fx-vc-git-skill-bot "$StackName"_fx-it-github-skill-bot "$StackName"_fx-it-fx-skill-bot "$StackName"_fx-it-jira-skill-bot "$StackName"_fx-cloud-aws-skill-bot "$StackName"_fx-notification-slack-skill-bot

sleep 5

echo "## DEPLOYING DEPENDENT SERVICES ##"
#docker stack deploy -c docker-compose-dependents.yaml uat1
#docker stack deploy -c docker-compose-dependents.yaml "$tag"
#docker stack deploy -c docker-compose-dependents.yaml $2

docker stack deploy -c docker-compose-dependents.yaml "$StackName"
sleep 10

### Removing & Deploying Haproxy ############
 
echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm uat1_fx-haproxy
#docker service rm "$tag"_fx-haproxy
#docker service rm $2_fx-haproxy

docker service rm "$StackName"_fx-haproxy
sleep 5

echo "## DEPLOYING HAPROXY SERVICE ##"
#docker stack deploy -c docker-compose-proxy.yaml uat1
#docker stack deploy -c docker-compose-proxy.yaml "$tag"
#docker stack deploy -c docker-compose-proxy.yaml $2

docker stack deploy -c docker-compose-proxy.yaml "$StackName"
sleep 10

# remove unused images
#docker rmi $(docker images -a -q)

docker service ls
sleep 5
docker ps
sleep 5
echo "Successfully Refreshed" "$StackName" "Environment."