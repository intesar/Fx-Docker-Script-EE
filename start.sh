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
mkdir -p /fxcloud/haproxy/dev1
cp haproxy_dev1.cfg /fxcloud/haproxy/dev1/haproxy.cfg
docker stack deploy -c docker-compose-data.yaml dev1
docker stack deploy -c docker-compose-proxy-dev1.yaml dev1

# Stg setup

docker stack deploy -c docker-compose-data.yaml stg
sleep 30
docker stack deploy -c docker-compose-control-plane.yaml stg
sleep 60
docker stack deploy -c docker-compose-dependents.yaml stg
docker stack deploy -c docker-compose-proxy.yaml stg

# Stg update
docker service rm stg_control-plane stg_fx-mail-bot stg_fx-vc-git-skill-bot stg_fx-bot stg_notification-email-skill-bot stg_issue-tracker-github-skill-bot stg_issue-tracker-jira-skill-bot
docker stack deploy -c docker-compose-control-plane.yaml stg
docker stack deploy -c docker-compose-dependents.yaml stg

# Prod update
docker service rm prod_fx-control-plane prod_fx-bot prod_fx-git-sync-bot prod_fx-mail-bot
docker stack deploy -c docker-compose-control-plane.yaml prod
docker stack deploy -c docker-compose-dependents.yaml prod


#### Stg history ######
       docker pull fxlabs/vc-git-skill-bot
 1450  docker pull fxlabs/bot
 1451  docker pull fxlabs/mail-bot
 1452  docker pull fxlabs/control-plane
 1453  cd /opt/fx/stg/Fx-Docker-Script
 1454  source .env
 1455  export $(cut -d= -f1 .env)
 1456  docker stack ls
 1458  docker service ls
 1461  docker service rm stg_fx-control-plane
 1462  docker stack deploy -c docker-compose-control-plane.yaml stg
 1463  docker service rm stg_fx-bot stg_fx-vc-git-skill-bot
 1464  docker stack deploy -c docker-compose-dependents.yaml stg
 1465  docker ps -a
 # Restart haproxy
 1466  docker restart eba2c9960e54
 1467  docker ps -a
 1468  docker exec -it 25886a117ce3 bash
 1469  history
