#!/bin/bash -x
# FXLABS UAT services update-script https://fxlabs.io/
# 2019-01-09
#

# Installer folder should have the following files
# 1.	.env
# 2.	docker-compose-data.yaml
# 3.	docker-compose-control-plane.yaml
# 4.	docker-compose-dependents.yaml
# 5.	fx-security-enterprise-proxy.yaml
# 6.	haproxy.cfg
# 7.	fx-security-enterprise-installer.sh
# 8.    fx-security-enterprise-update.sh

## sudo chmod 755 -R /Fx-Docker-Script/
## cd /path-of-these-files eg. cd /Fx-Docker-Script 
## sudo su
## "run below command from path of the above files
## ./controlplane-haproxy-update-script.sh

#read -p "Enter image tag: " tag


##cd /opt/fx/uat/Fx-Docker-Script/
source .env
export $(cut -d= -f1 .env)

############ Pulling latest build fxlabs images ############

echo "## PULLING LATEST BUILD FXLABS/CONTROL-PLANE IMAGE ##"


# pull images on other nodes.
docker pull fxlabs/control-plane:$1

#echo "## ENTER STACK NAME TAG (as uat1) ##"

#read -p "Enter stack name tag: " tag

### Removing & Deploying Control-Plane Service ############

echo "## REMOVING CONTROL-PLANE SERVICE ##"
#docker service rm uat1_fx-control-plane
#docker service rm "$tag"_fx-control-plane
docker service rm $2_fx-control-plane

sleep 5

echo "DEPLOYING CONTROL-PLANE SERVICE"
#docker stack deploy -c docker-compose-control-plane.yaml uat1
#docker stack deploy -c docker-compose-control-plane.yaml "$tag"
docker stack deploy -c docker-compose-control-plane.yaml $2
sleep 30



### Removing & Deploying Haproxy ############
 
echo "## REMOVING HAPROXY SERVICE ##"
#docker service rm uat1_fx-haproxy
#docker service rm "$tag"_fx-haproxy
docker service rm $2_fx-haproxy
sleep 5

echo "DEPLOYING HAPROXY SERVICE"
#docker stack deploy -c docker-compose-proxy.yaml uat1
#docker stack deploy -c docker-compose-proxy.yaml "$tag"
docker stack deploy -c docker-compose-proxy.yaml $2
sleep 10

# remove unused images
#docker rmi $(docker images -a -q)

docker service ls
sleep 5
docker ps
sleep 5
echo "Successfully refreshed" $2 "Environment."
