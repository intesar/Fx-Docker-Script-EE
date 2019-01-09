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

read -p "Enter tag: " tag

echo "Pulling latest build fxlabs images"

#3.	Pull fx-security-enterprise docker images (based on the tag input)
docker pull fxlabs/control-plane-ee:"$tag"
docker pull fxlabs/vc-git-skill-bot-ee:"$tag"
docker pull fxlabs/bot-ee:"$tag"
docker pull fxlabs/notification-email-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-github-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-jira-skill-bot-ee:"$tag"
docker pull fxlabs/issue-tracker-fx-skill-bot-ee:"$tag"
docker pull fxlabs/cloud-aws-skill-bot-ee:"$tag"
docker pull fxlabs/notification-slack-skill-bot-ee:"$tag"


source .env
export $(cut -d= -f1 .env)

#Removing & Deploying Control-Plane Service

echo "Removing Control-Plane Service"
docker service rm prod_fx-control-plane-ee
sleep 3

echo "Deploying Control-Plane Service"
docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml prod
sleep 60

##Removing & Deploying dependent services

echo "Removing Dependent Services"
docker service rm prod_fx-mail-bot-ee prod_fx-vc-git-skill-bot-ee prod_fx-it-github-skill-bot-ee prod_fx-it-jira-skill-bot-ee prod_fx-cloud-aws-skill-bot-ee prod_fx-notification-slack-skill-bot-ee
sleep 10

echo "Deploying Dependent Services"
docker stack deploy -c fx-security-enterprise-dependents-ee.yaml prod
sleep 30

##Removing & Deploying Haproxy

echo "Removing Haproxy Service"
docker service rm prod_fx-haproxy
sleep 3

echo "Deploying Haproxy Service"
docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  prod
sleep 10
docker service ls
sleep 5

echo "Services Successfully Refreshed"




 

