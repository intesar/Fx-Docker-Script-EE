#!/bin/bash -x
# FX security enterprise installer script https://fxlabs.io/
# 20181224

# Installer folder should have the following files
# 1.	.env
# 2.	fx-security-enterprise-data-ee.yaml
# 3.	fx-security-enterprise-control-plane-ee.yaml
# 4.	fx-security-enterprise-dependents-ee.yaml
# 5.	fx-security-enterprise-haproxy-ee.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh

read -p "Enter tag: " tag

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

#Removing & Deploying Control Plane

docker service rm prod_fx-control-plane-ee
docker stack deploy -c fx-security-enterprise-control-plane-ee.yaml prod
sleep 60

##Removing & Deploying dependents services

docker service rm prod_fx-mail-bot-ee prod_fx-vc-git-skill-bot-ee prod_fx-it-github-skill-bot-ee prod_fx-it-jira-skill-bot-ee prod_fx-cloud-aws-skill-bot-ee prod_fx-notification-slack-skill-bot-ee
docker service rm prod_fx-cloud-aws-skill-bot-ee
docker stack deploy -c fx-security-enterprise-dependents-ee.yaml prod
sleep 30

##Removing & Deploying Haproxy

docker service rm prod_fx-haproxy
docker stack deploy -c fx-security-enterprise-haproxy-ee.yaml  prod
sleep 5

echo "Production Successfully Refreshed"




 

