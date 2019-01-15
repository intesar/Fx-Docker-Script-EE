#!/bin/bash

set -x
docker ps
read -p "Enter Haproxy ID:" id
docker pull fxlabs/control-plane
docker service rm uat1_fx-control-plane
docker stack deploy -c docker-compose-control-plane.yaml stg
docker restart $id

sleep 30s

docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/notification-email-skill-bot
docker pull fxlabs/issue-tracker-github-skill-bot
docker pull fxlabs/issue-tracker-jira-skill-bot
docker pull fxlabs/cloud-aws-skill-bot
docker pull fxlabs/notification-slack-skill-bot

docker service rm uat1_fx-mail-bot uat1_fx-vc-git-skill-bot uat1_fx-it-github-skill-bot uat1_fx-it-jira-skill-bot uat1_fx-cloud-aws-skill-bot uat1_fx-notification-slack-skill-bot
docker stack deploy -c docker-compose-dependents.yaml stg
set  +x
echo "Successfully refreshed UAT Environment."
