#!/bin/bash -x
# FX security enterprise installer script https://fxlabs.io/
# 2019-01-08

# Installer folder should have the following files
# 1.	.env
# 2.	fx-security-enterprise-data-ee.yaml
# 3.	fx-security-enterprise-control-plane-ee.yaml
# 4.	fx-security-enterprise-dependents-ee.yaml
# 5.	fx-security-enterprise-haproxy-ee.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh
# 8.    fx-security-enterprise-update.sh

# sudo chmod 755 -R /Fx-Docker-Script/fx-security-enterprise
# cd /path-of-these-files eg. cd /fx-security-enterprise/ 
# sudo su
# "run below command from path of the above files
#### ./fx-security-enterprise-update.sh latest PROD env

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
#docker service rm "$tag"_fx-control-plane-ee
#docker service rm $2_fx-control-plane-ee

docker service rm "$StackName"_fx-control-plane-ee
sleep 3

echo "DEPLOYING CONTROL-PLANE SERVICE"
#docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml "$tag"
docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml $2

docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml "$StackName"
sleep 30

##Removing & Deploying dependent services

echo "## REMOVING DEPENDENT SERVICES ##"
#docker service rm "$tag"_fx-it-fx-skill-bot-ee "$tag"_fx-mail-bot-ee "$tag"_fx-vc-git-skill-bot-ee "$tag"_fx-it-github-skill-bot-ee "$tag"_fx-it-jira-skill-bot-ee "$tag"_fx-cloud-aws-skill-bot-ee "$tag"_fx-notification-slack-skill-bot-ee
#docker service rm $2_fx-it-fx-skill-bot-ee $2_fx-mail-bot-ee $2_fx-vc-git-skill-bot-ee $2_fx-it-github-skill-bot-ee $2_fx-it-jira-skill-bot-ee $2_fx-cloud-aws-skill-bot-ee $2_fx-notification-slack-skill-bot-ee

docker service rm "$StackName"_fx-it-fx-skill-bot-ee "$StackName"_fx-mail-bot-ee "$StackName"_fx-vc-git-skill-bot-ee "$StackName"_fx-it-github-skill-bot-ee "$StackName"_fx-it-jira-skill-bot-ee "$StackName"_fx-cloud-aws-skill-bot-ee "$StackName"_fx-notification-slack-skill-bot-ee
sleep 10

echo "## DEPLOYING DEPENDENT SERVICES ##"
#docker stack deploy -c fx-security-enterprise-dependents-ee.yaml "$tag"
#docker stack deploy -c fx-security-enterprise-dependents-ee.yaml $2

docker stack deploy -c fx-security-enterprise-dependents-ee.yaml "$StackName"
sleep 10

##Removing & Deploying Haproxy##

echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm "$tag"_fx-haproxy
#docker service rm $2_fx-haproxy

docker service rm "$StackName"_fx-haproxy
sleep 3

echo "## DEPLOYING HAPROXY SERVICE ##"
#docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  "$tag"
#docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  $2

docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  "$StackName"
sleep 10
docker service ls
sleep 5

echo "$StackName" "SERVICES SUCCESSFULLY REFRESHED!!! "