#!/bin/bash
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #

#Imports 
. /vagrant/bin/utils/loging.sh

export GC_TLS_ENABLED="false"
export GC_PDC_ENABLED="true"

#0 CLEAR ENTIRE ENVIRONMENT
##### CLEAN DOCKER #####
docker rm $(docker stop $(docker ps -aq))
docker volume rm $(docker volume list -q)
docker network prune
docker network rm $(docker network list -q)
#CLEAN PROJECT DIRECTORIES
rm -rf $FABRIC_CA_CLIENT_HOME
rm -rf /vagrant/config/crypto-config
#CLEAN CA DIRECTORIES
rm -rf /vagrant/ca/server/config/*
rm -rf /vagrant/ca/client/config/*
#CLEAN ORDERER DIRECTORIES
rm -rf /vagrant/orderer/config/*
#CLEAN PEER DIRECTORIES
rm -rf /vagrant/peer/config/*

######## set_project_name ############
export COMPOSE_PROJECT_NAME=gcbc

#1COPY CONFIG FILES FROM BASE DIRECTORIES
if [ $GC_TLS_ENABLED == "true" ]
then
    BASE_CONFING_PATH=/vagrant/base-config-files/raft
else
    BASE_CONFING_PATH=/vagrant/base-config-files/solo
fi

mkdir -p /vagrant/ca/server/config
mkdir -p /vagrant/orderer/config
mkdir -p /vagrant/peer/config
mkdir -p /vagrant/rabbitmq/config

cp $BASE_CONFING_PATH/ca/* /vagrant/ca/server/config/
cp $BASE_CONFING_PATH/orderer/* /vagrant/orderer/config/
cp $BASE_CONFING_PATH/peer/* /vagrant/peer/config/
cp $BASE_CONFING_PATH/configtx/* /vagrant/peer/config/
cp $BASE_CONFING_PATH/configtx/* /vagrant/orderer/config/
cp $BASE_CONFING_PATH/rabbitmq/* /vagrant/rabbitmq/config/


#2 INIT CA SERVER 
docker-compose -f /vagrant/ca/server/config/docker-compose-ca.yaml up -d
#WAIT FOR CONTAINER START UP
sleep 5
#CLEAN CA USERS
/vagrant/bin/setup-env/clear-dev-crypto-ca.sh

#3 SETUP GRAINCHAIN DEV CRYPTO CONFIG
/vagrant/bin/setup-env/setup-dev-crypto-ca.sh

#4 CREATE GENESIS BLOCK AND GRAINCHAIN INIT CHANNEL TX
#erase previous blocks and tx files 
rm -rf /vagrant/peer/config/*.block
rm -rf /vagrant/orderer/config/*.block
rm -rf /vagrant/config/*.block
rm -rf /vagrant/config/*.tx
rm -rf /vagrant/peer/config/*.tx
rm -rf /vagrant/orderer/config/*.tx

#### execute the genesis script in tools container ###
docker exec -it tools.grainchain.io sh -c "/opt/scripts/gcscripts/bin/tools/genesis-script.sh"
#### copy genesis block to orderer config folder
cp /vagrant/peer/config/grainchainchannel-genesis.block /vagrant/orderer/config
__msg_info "=====> TX file $OUTPUT_CHANNEL_TX copied to: peer/config folder"

#5 RUN ORDERER CONTAINER(S)
docker-compose -f /vagrant/orderer/config/docker-compose-orderer.yaml up -d

#6 RUN PEER CONTAINER(S)
docker-compose -f /vagrant/peer/config/docker-compose-peer.yaml up -d

#7 RUN RABBIT MQ
docker-compose -f /vagrant/rabbitmq/config/docker-compose-rabbitmq.yaml up -d

#8 CREATE PEERS CHANNEL JOIN AND UPDATE ANCHOR
docker exec -it tools.grainchain.io sh -c "/opt/scripts/gcscripts/bin/tools/create-channel-script.sh"

#9 DEPLOY AND TEST THE CHAINCODE
docker exec -it tools.grainchain.io sh -c "/opt/scripts/gcscripts/bin/tools/deploy-test-cc-script.sh $GC_PDC_ENABLED"