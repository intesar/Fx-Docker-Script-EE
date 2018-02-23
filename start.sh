#!/bin/bash

docker node update --label-add fx-node=true NODE-ID
# pull images on other nodes.
docker pull fxlabs/git-sync-bot
docker pull fxlabs/control-plane
docker pull fxlabs/bot
docker pull fxlabs/mail-bot

# create volumes -
mkdir -p /fxcloud/elasticsearch/data
mkdir -p /fxcloud/postgres/data
mkdir -p /fxcloud/rabbitmq/data

source .env
export $(cut -d= -f1 .env)

docker stack deploy -c docker-compose-data.yaml stg1
sleep 30
docker stack deploy -c docker-compose-control-plane.yaml stg1
sleep 60
docker stack deploy -c docker-compose-dependents.yaml stg1
