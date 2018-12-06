#!/bin/bash

cd /opt/fx/uat/Fx-Docker-Script
source .env
export $(cut -d= -f1 .env)

# pull images on other nodes.
docker pull fxlabs/control-plane
docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/notification-email-skill-bot
docker pull fxlabs/issue-tracker-github-skill-bot
docker pull fxlabs/issue-tracker-fx-skill-bot
docker pull fxlabs/issue-tracker-jira-skill-bot
docker pull fxlabs/cloud-aws-skill-bot
docker pull fxlabs/notification-slack-skill-bot

docker service rm uat1_fx-control-plane

sleep 30

docker stack deploy -c docker-compose-control-plane.yaml uat1

docker service rm uat1_fx-mail-bot uat1_fx-vc-git-skill-bot uat1_fx-it-github-skill-bot uat1_fx-it-fx-skill-bot uat1_fx-it-jira-skill-bot uat1_fx-cloud-aws-skill-bot uat1_fx-notification-slack-skill-bot

sleep 60

docker stack deploy -c docker-compose-dependents.yaml uat1

docker service rm uat1_fx-haproxy

sleep 30

docker stack deploy -c docker-compose-proxy.yaml uat1

# remove unused images
docker rmi $(docker images -a -q)

docker service ls
docker ps
echo "Successfully refreshed UAT Environment."



