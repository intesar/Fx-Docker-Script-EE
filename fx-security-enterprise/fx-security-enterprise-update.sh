#!/bin/bash -x
# FX security enterprise update script https://fxlabs.io/
# 2019-01-08

# Installer folder should have the following files
# 1.	.env
# 2.	fx-security-enterprise-data.yaml
# 3.	fx-security-enterprise-control-plane.yaml
# 4.	fx-security-enterprise-dependents.yaml
# 5.	fx-security-enterprise-haproxy.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh
# 8.    fx-security-enterprise-update.sh

# sudo chmod 744-R /Fx-Docker-Script-EE/fx-security-enterprise/fx-security-enterprise-update.sh
# cd /path-of-these-files eg. cd /Fx-Docker-Script-EE/fx-security-enterprise/ 
# sudo su
# "run below command with appropriate and respective parameters  from path of the above files
#### ./fx-security-enterprise-update.sh   <ImageTag> <StackName> <envFileName>
### eg: ./fx-security-enterprise-update.sh  latest      PROD        env

#read -p "Enter image tag: " tag

ImageTag=$1
StackName=$2
env=$3

echo "## PULLING LATEST BUILD FXLABS IMAGES ##"

#3.	Pull fx-security-enterprise docker images (based on the tag input)
#docker pull fxlabs/control-plane-ee:"$tag"
#docker pull fxlabs/vc-git-skill-bot-ee:"$tag"
#docker pull fxlabs/notification-email-skill-bot-ee:"$tag"
#docker pull fxlabs/issue-tracker-github-skill-bot-ee:"$tag"
#docker pull fxlabs/issue-tracker-jira-skill-bot-ee:"$tag"
#docker pull fxlabs/issue-tracker-fx-skill-bot-ee:"$tag"
#docker pull fxlabs/cloud-aws-skill-bot-ee:"$tag"
#docker pull fxlabs/notification-slack-skill-bot-ee:"$tag"

docker pull fxlabs/control-plane-ee:"$ImageTag"
docker pull fxlabs/vc-git-skill-bot-ee:"$ImageTag"
docker pull fxlabs/notification-email-skill-bot-ee:"$ImageTag"
docker pull fxlabs/issue-tracker-github-skill-bot-ee:"$ImageTag"
docker pull fxlabs/issue-tracker-jira-skill-bot-ee:"$ImageTag"
docker pull fxlabs/issue-tracker-fx-skill-bot-ee:"$ImageTag"
docker pull fxlabs/cloud-aws-skill-bot-ee:"$ImageTag"
docker pull fxlabs/notification-slack-skill-bot-ee:"$ImageTag"

#source .env
#export $(cut -d= -f1 .env)
#echo "ENTER STACK NAME TAG "

source ."$env"
export $(cut -d= -f1 ."$env")

#read -p "Enter stack name tag: " tag

#Removing & Deploying Control-Plane Service

echo "## REMOVING CONTROL-PLANE SERVICE ##"
#docker service rm "$tag"_fx-control-plane
#docker service rm $2_fx-control-plane

docker service rm "$StackName"_fx-control-plane
sleep 3

echo "DEPLOYING CONTROL-PLANE SERVICE"
#docker stack deploy -c fx-security-enterprise-control-plane.yaml "$tag"
#docker stack deploy -c fx-security-enterprise-control-plane.yaml $2

docker stack deploy -c fx-security-enterprise-control-plane.yaml "$StackName"
sleep 30

##Removing & Deploying dependent services

echo "## REMOVING DEPENDENT SERVICES ##"
#docker service rm "$tag"_fx-it-fx-skill-bot "$tag"_fx-mail-bot "$tag"_fx-vc-git-skill-bot "$tag"_fx-it-github-skill-bot "$tag"_fx-it-jira-skill-bot "$tag"_fx-cloud-aws-skill-bot "$tag"_fx-notification-slack-skill-bot
#docker service rm $2_fx-it-fx-skill-bot $2_fx-mail-bot $2_fx-vc-git-skill-bot $2_fx-it-github-skill-bot $2_fx-it-jira-skill-bot $2_fx-cloud-aws-skill-bot $2_fx-notification-slack-skill-bot

docker service rm "$StackName"_fx-it-fx-skill-bot "$StackName"_fx-mail-bot "$StackName"_fx-vc-git-skill-bot "$StackName"_fx-it-github-skill-bot "$StackName"_fx-it-jira-skill-bot "$StackName"_fx-cloud-aws-skill-bot "$StackName"_fx-notification-slack-skill-bot
sleep 10

echo "## DEPLOYING DEPENDENT SERVICES ##"
#docker stack deploy -c fx-security-enterprise-dependents-ee.yaml "$tag"
#docker stack deploy -c fx-security-enterprise-dependents-ee.yaml $2

docker stack deploy -c fx-security-enterprise-dependents.yaml "$StackName"
sleep 10

##Removing & Deploying Haproxy##

echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm "$tag"_fx-haproxy
#docker service rm $2_fx-haproxy

docker service rm "$StackName"_fx-haproxy
sleep 3

echo "## DEPLOYING HAPROXY SERVICE ##"
#docker stack deploy -c fx-security-enterprise-haproxy.yaml  "$tag"
#docker stack deploy -c fx-security-enterprise-haproxy.yaml  $2

docker stack deploy -c fx-security-enterprise-haproxy.yaml  "$StackName"
sleep 10
docker service ls
sleep 5

echo "$StackName" "SERVICES SUCCESSFULLY REFRESHED!!! "
