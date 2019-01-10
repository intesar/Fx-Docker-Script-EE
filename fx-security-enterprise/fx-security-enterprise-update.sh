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
# ./fx-security-enterprise-update.sh

read -p "Enter image tag: " tag

echo "## PULLING LATEST BUILD FXLABS IMAGES ##"

#3.	Pull fx-security-enterprise docker images (based on the tag input)
docker pull fxlabs/control-plane-ee:"$tag"
docker pull fxlabs/vc-git-skill-bot-ee:"$tag"
docker pull fxlabs/notification-email-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-github-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-jira-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-fx-skill-bot-ee:"$tag"
docker pull fxlabs/cloud-aws-skill-bot-ee:"$tag"
docker pull fxlabs/notification-slack-skill-bot-ee:"$tag"


source .env
export $(cut -d= -f1 .env)
echo "ENTER STACK NAME TAG "

read -p "Enter stack name tag: " tag

#Removing & Deploying Control-Plane Service

echo "## REMOVING CONTROL-PLANE SERVICE ##"
docker service rm "$tag"_fx-control-plane-ee
sleep 3

echo "DEPLOYING CONTROL-PLANE SERVICE"
docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml "$tag"
sleep 60

##Removing & Deploying dependent services

echo "## REMOVING DEPENDENT SERVICES ##"
docker service rm "$tag"_fx-it-fx-skill-bot-ee "$tag"_fx-mail-bot-ee "$tag"_fx-vc-git-skill-bot-ee "$tag"_fx-it-github-skill-bot-ee "$tag"_fx-it-jira-skill-bot-ee "$tag"_fx-cloud-aws-skill-bot-ee "$tag"_fx-notification-slack-skill-bot-ee
sleep 10

echo "## DEPLOYING DEPENDENT SERVICES ##"
docker stack deploy -c fx-security-enterprise-dependents-ee.yaml "$tag"
sleep 30

##Removing & Deploying Haproxy##

echo "## REMOVING HAPROXY SERVICE ##"
docker service rm "$tag"_fx-haproxy
sleep 3

echo "## DEPLOYING HAPROXY SERVICE ##"
docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  "$tag"
sleep 10
docker service ls
sleep 5

echo " "$tag" SERVICES SUCCESSFULLY REFRESHED!!! "