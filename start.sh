#!/bin/bash

docker node update --label-add fx-node=true NODE-ID
# pull images on other nodes.
#docker pull fxlabs/git-sync-bot
docker pull fxlabs/vc-git-skill-bot
docker pull fxlabs/bot
docker pull fxlabs/mail-bot
docker pull fxlabs/control-plane
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

source .env
export $(cut -d= -f1 .env)

docker stack deploy -c docker-compose-data.yaml stg
sleep 30
docker stack deploy -c docker-compose-control-plane.yaml stg
sleep 60
docker stack deploy -c docker-compose-dependents.yaml stg

docker stack deploy -c docker-compose-proxy.yaml stg
