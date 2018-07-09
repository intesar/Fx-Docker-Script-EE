#!/bin/bash

docker node update --label-add fx-node=true NODE-ID

# create volumes -
mkdir -p /fxcloud/elasticsearch/data
mkdir -p /fxcloud/postgres/data
mkdir -p /fxcloud/rabbitmq/data

#Elastic search fix
sysctl -w vm.max_map_count=262144

# Only on prod these paths should exists
mkdir -p /fxcloud/postgres/data
mkdir -p /fxcloud/elasticsearch/data
mkdir -p /fxcloud/rabbitmq/data
mkdir -p /fxcloud/haproxy

cd /opt/fx/stg/Fx-Docker-Script
source .env
export $(cut -d= -f1 .env)

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

docker stack deploy -c docker-compose-data.yaml stg
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

######################################################
################## Stg update  ######################
######################################################


ssh -i fx-staging.pem ubuntu@13.57.51.56

cd /opt/fx/stg/Fx-Docker-Script
source .env
export $(cut -d= -f1 .env)

# pull images on other nodes.
docker pull fxlabs/control-plane
docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/notification-email-skill-bot
docker pull fxlabs/issue-tracker-github-skill-bot
docker pull fxlabs/issue-tracker-jira-skill-bot
docker pull fxlabs/cloud-aws-skill-bot
docker pull fxlabs/notification-slack-skill-bot

docker service rm stg_fx-control-plane
docker stack deploy -c docker-compose-control-plane.yaml stg

docker service rm stg_fx-mail-bot stg_fx-vc-git-skill-bot stg_fx-it-github-skill-bot stg_fx-it-jira-skill-bot stg_fx-cloud-aws-skill-bot stg_fx-notification-slack-skill-bot
docker stack deploy -c docker-compose-dependents.yaml stg
docker service rm stg_fx-mail-bot

docker restart [haproxy]

# You should never delete data services
docker service rm stg_fx-elasticsearch stg_fx-postgres stg_fx-rabbitmq
docker stack deploy -c docker-compose-data.yaml stg

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

######################################################
################## Prod update  ######################
######################################################
git pull --rebase

ssh -i fx-prod ubuntu@cloud.fxlabs.io
sudo su
cd /opt/fxlabs/Fx/Fx-Docker-Script


source .env-prod
export $(cut -d= -f1 .env-prod)

docker pull fxlabs/control-plane
docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/notification-email-skill-bot
docker pull fxlabs/issue-tracker-github-skill-bot
docker pull fxlabs/issue-tracker-jira-skill-bot
docker pull fxlabs/cloud-aws-skill-bot
docker pull fxlabs/notification-slack-skill-bot

docker service rm prod_fx-control-plane
docker stack deploy -c docker-compose-control-plane.yaml prod

docker service rm prod_fx-mail-bot prod_fx-vc-git-skill-bot prod_fx-it-github-skill-bot prod_fx-it-jira-skill-bot prod_fx-cloud-aws-skill-bot prod_fx-notification-slack-skill-bot
docker service rm prod_fx-cloud-aws-skill-bot
docker stack deploy -c docker-compose-dependents.yaml prod

docker service rm prod_fx-elasticsearch prod_fx-postgres prod_fx-rabbitmq
docker stack deploy -c docker-compose-data-prod.yaml prod

# Mount additional disks and create a sub data directory
mkdir -p /fxcloud/postgres/data
mkdir -p /fxcloud/elasticsearch/data

 ################## Restart haproxy ##################
 1466  docker restart eba2c9960e54
 1467  docker ps -a
 1468  docker exec -it 25886a117ce3 bash
 1469  history

################## Disk ##################
sudo apt install ncdu
ncdu /
df -h
vi /etc/logrotate.d/rsyslog
logrotate -v /etc/logrotate.d/rsyslog
# truncate syslog
dd if=/dev/null of=/var/log/syslog
