#!/bin/bash

source .env
export $(cut -d= -f1 .env)
docker stack deploy -c docker-compose-data.yaml stg1
sleep 30
docker stack deploy -c docker-compose-control-plane.yaml stg1
sleep 60
docker stack deploy -c docker-compose-dependents.yaml stg1