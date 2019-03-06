#!/bin/bash
### NOTE!!! TO MAKE CRONJOB DON'T AUTO TRIGGER  "fx-security-enterprise-autoupdate.sh" FILE FOR UPDATING/REFRESHING OF FX-LABS SERVICES !!!! ###
### CHANGE/PASS (NO,No,nO,no) AFTER  (=) SIGN,  TO THIS LINE "auto.deploy.active = " IN FXAutoDeploy.properties FILE ### 
### WHILE ANY OTHER CHARACTER TO THIS LINE "auto.deploy.active = " AFTER  (=) SIGN WILL TRIGGER "fx-security-enterprise-autoupdate.sh" FILE AND AUTO-REFRESHED FX-LABS SERVICES ###                                                                                                         
### (THIS CRONJOB AND "FXAutoDeploy.properties" FILE WILL BE CREATED AFTER  RUNNING "fx-security-enterprise-installer.sh" SCRIPT) ###

whoami
pwd
ls
compare="auto.deploy.active"
PWD=`pwd`
while IFS= read -r line
do
  rest="$line"
   name="${line% =*}"
   if [ "$compare" == "$name" ];
   then
    echo "This line content is needed"
    echo "$name"
   break
   else
    echo "This line content is not needed "
   fi
done <  $PWD/FXAutoDeploy.properties
echo "$rest"
test="${rest#*= }"
echo "$test"
sleep 15
echo "Modified Line content is $test"
var1=no
var2=nO
var3=No
var4=NO
if [ "$test" = "$var1" -o "test" = "$var2" -o "$test" = "$var3" -o "$test" = "$var4"  ];
then
    echo "Script Execution is Not Required"
    exit 1
else
  echo "Script Execution is  required"
  echo "$test"
  echo "$name"
sleep 10

CONTAINERID=$(sudo docker ps -q -f name=fx-rabbitmq)
echo "$CONTAINERID"
sleep 5
STACKNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.stack.namespace" }}' $CONTAINERID)
echo "$STACKNAME"
sleep 5
./fx-security-enterprise-update.sh latest $STACKNAME env
sleep 30


echo "### Running Containers Validation ####  "

rabbitmqID=$(sudo docker ps -q -f name=fx-rabbitmq)
echo "RabbitMQ ID is $rabbitmqID"
rabbitmqNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $rabbitmqID)
echo "RabbitMQ Container Name is $rabbitmqNAME"
if [ $(docker inspect -f '{{.State.Running}}' $rabbitmqNAME) = "true" ]; then echo "fx-rabbitmq  container $rabbitmqNAME is running."; else echo "fx-rabbitmq container $rabbitmqNAME is not running."; fi
echo " "

postgresID=$(sudo docker ps -q -f name=fx-postgres)
echo "Postgres ID is $postgresID"
postgresNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $postgresID)
echo "Postgres Container Name is $postgresNAME"
if [ $(docker inspect -f '{{.State.Running}}' $postgresNAME) = "true" ]; then echo "fx-postgres container $postgresNAME  is running"; else echo "fx-postgres container $postgresNAME is not running"; fi
echo " "

elasticsearchID=$(sudo docker ps -q -f name=fx-elasticsearch)
echo "ElasticSearch ID is $elasticsearchID"
elasticsearchNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $elasticsearchID)
echo "ElasticSearch Container Name is $elasticsearchNAME"
if [ $(docker inspect -f '{{.State.Running}}' $elasticsearchNAME) = "true" ]; then echo "fx-elasticsearch container $elasticsearchNAME  is running"; else echo "fx-elasticsearch container $elasticsearchNAME  is not running"; fi
echo " "

controlplaneID=$(sudo docker ps -q -f name=fx-control-plane)
echo "Control-Plane ID is $controlplaneID"
controlplaneNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $controlplaneID)
echo "Control-Plane Container Name is $controlplaneNAME"
if [ $(docker inspect -f '{{.State.Running}}' $controlplaneNAME) = "true" ]; then echo "fx-control-plane container $controlplaneNAME is running"; else echo "fx-control-plane container $controlplaneNAME is not running"; fi
echo " "


mailbotID=$(sudo docker ps -q -f name=fx-mail-bot)
echo "Emailbot ID is $mailbotID"
mailbotNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $mailbotID)
echo " Emailbot Container Name is $mailbotNAME"
if [ $(docker inspect -f '{{.State.Running}}' $mailbotNAME) = "true" ]; then echo "fx-mail-bot container $mailbotNAME is running"; else echo "fx-mail-bot container $mailbotNAME is not running"; fi
echo " "


vcgitID=$(sudo docker ps -q -f name=fx-vc-git-skill-bot)
echo "VcGit ID is $vcgitID"
vcgitNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $vcgitID)
echo "VcGit Container Name is $vcgitNAME"
if [ $(docker inspect -f '{{.State.Running}}' $vcgitNAME) = "true" ]; then echo "fx-vc-git-skill-bot container $vcgitNAME  is running"; else echo "fx-vc-git-skill-bot container $vcgitNAME  is not running"; fi
echo " "


githubID=$(sudo docker ps -q -f name=fx-it-github-skill-bot)
echo "Github ID is $githubID"
githubNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $githubID)
echo "Github Container Name is $githubNAME"
if [ $(docker inspect -f '{{.State.Running}}' $githubNAME) = "true" ]; then echo "fx-it-github-skill-bot container $githubNAME  is running"; else echo "fx-it-github-skill-bot container $githubNAME is not running"; fi
echo " "


cloudawsID=$(sudo docker ps -q -f name=fx-cloud-aws-skill-bot)
echo "Cloud-AWS ID is $cloudawsID"
cloudawsNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $cloudawsID)
echo "Cloud-AWS Container Name is $cloudawsNAME "
if [ $(docker inspect -f '{{.State.Running}}' $cloudawsNAME) = "true" ]; then echo "fx-cloud-aws-skill-bot container $cloudawsNAME is running"; else echo "fx-cloud-aws-skill-bot container $cloudawsNAME  is not running"; fi
echo " "


slackID=$(sudo docker ps -q -f name=fx-notification-slack-skill-bot)
echo "slackID is $slackID"
slackNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $slackID)
echo "Slack Container Name is $slackNAME"
if [ $(docker inspect -f '{{.State.Running}}' $slackNAME) = "true" ]; then echo "fx-notification-slack-skill-bot container $slackNAME  is running"; else echo "fx-notification-slack-skill-bot container $slackNAME  is not running"; fi
echo " "


skillbotID=$(sudo docker ps -q -f name=fx-it-fx-skill-bot)
echo "Fx-Skill-Bot ID is $skillbotID"
skillbotNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $skillbotID)
echo "Fx-Skill-Bot Container Name is $skillbotNAME "
if [ $(docker inspect -f '{{.State.Running}}' $skillbotNAME) = "true" ]; then echo "fx-it-fx-skill-bot container $skillbotNAME  is running"; else echo "fx-it-fx-skill-bot container $skillbotNAME  is not running"; fi
echo " "

jiraID=$(sudo docker ps -q -f name=fx-it-jira-skill-bot)
echo "Jira ID is $jiraID"
jiraNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $jiraID)
echo " Jira Container Name is $jiraNAME"
if [ $(docker inspect -f '{{.State.Running}}' $jiraNAME) = "true" ]; then echo "fx-it-jira-skill-bot container $jiraNAME  is running"; else echo "fx-it-jira-skill-bot container $jiraNAME  is not running"; fi
echo " "

haproxyID=$(sudo docker ps -q -f name=fx-haproxy)
echo "Haproxy ID is $haproxyID"
haproxyNAME=$(sudo docker inspect --format='{{index .Config.Labels "com.docker.swarm.task.name" }}' $haproxyID)
echo "Haproxy Container Name is $haproxyNAME"
if [ $(docker inspect -f '{{.State.Running}}' $haproxyNAME) = "true" ]; then echo "fx-haproxy container $haproxyNAME  is running"; else echo "fx-haproxy container $haproxyNAME  is not running"; fi
echo " "

sleep 10

echo " "
echo "Validting Whether localhost running or not"

TARGET=localhost
if curl -I "http://$TARGET"; then
  echo "$TARGET alive and web site is up"
else
  echo "$TARGET offline or web server problem"
fi
echo " "
echo "Fxlabs Services Auto-Updated Successfully!!!"
fi

