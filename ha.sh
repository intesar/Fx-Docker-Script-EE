#!/bin/bash
install docker
sysctl -w vm.max_map_count=262144

source .env
export $(cut -d= -f1 .env)

docker stack deploy -c docker-compose-data.yaml uat2

docker swarm init

docker docker-compose-data.yaml up -d


tail -f /var/log/syslog | grep fx
tail -f /var/log/syslog | grep bot
tail -f /var/log/syslog | grep control
tail -f /var/log/syslog | grep -C 5 exception




cd /opt/fx/stg/Fx-Docker-Script


# pull images on other nodes.
docker pull fxlabs/control-plane
docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/notification-email-skill-bot
docker pull fxlabs/issue-tracker-github-skill-bot
docker pull fxlabs/issue-tracker-jira-skill-bot


# Dev setup
git pull --rebase
mkdir -p /fxcloud/haproxy
cp haproxy_dev1.cfg /fxcloud/haproxy/haproxy.cfg
docker stack deploy -c docker-compose-data.yaml dev
docker stack deploy -c docker-compose-proxy.yaml dev

# Stg setup


sleep 30
docker stack deploy -c docker-compose-control-plane.yaml stg
sleep 60
docker stack deploy -c docker-compose-dependents.yaml stg
docker stack deploy -c docker-compose-proxy.yaml stg

# Docker, Jenkins, Nexus
https://hub.docker.com/
Docker ID: fxlabs
Password: FunctionLabs1234!

Jenkins
http://stg1.fxlabs.io:8083/
admin/FunctionLabs1234!





# postgres
docker exec -it <postgres>
psql -U fx_admin fx

######################################################
################## UAT update  ######################
######################################################


ssh -i FX-UAT.pem ubuntu@13.56.210.25
sudo su
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
docker stack deploy -c docker-compose-control-plane.yaml uat1

docker service rm uat1_fx-mail-bot uat1_fx-vc-git-skill-bot uat1_fx-it-github-skill-bot uat1_fx-it-fx-skill-bot uat1_fx-it-jira-skill-bot uat1_fx-cloud-aws-skill-bot uat1_fx-notification-slack-skill-bot
docker stack deploy -c docker-compose-dependents.yaml uat1

docker restart [haproxy]

# You should never delete data services
docker service rm uat_fx-elasticsearch uat_fx-postgres uat_fx-rabbitmq
docker stack deploy -c docker-compose-data.yaml uat

# remove unused images
docker rmi $(docker images -a -q)

docker ps
docker service ls
df -h

tail -f /var/log/syslog | grep fx
tail -f /var/log/syslog | grep bot
tail -f /var/log/syslog | grep control
tail -f /var/log/syslog | grep -C 5 exception

# postgres
docker exec -it <postgres>
psql -U fx_admin fx


