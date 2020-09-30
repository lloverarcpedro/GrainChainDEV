#!/bin/bash
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #
cd /var/hyperledger/config
export MSP_ID=GrainchainMSP
export ORG_NAME=GrainchainMSP
export CORE_PEER_LOCALMSPID=GrainchainMSP
export CORE_PEER_ADDRESS="peer1.grainchain.io:7051"
export ORDERER_ADDRESS="orderer1.grainchain.io:7050"
export CORE_PEER_MSPCONFIGPATH="/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/harvx.io/users/Admin@harvx.io/msp"
export GC_CHANNEL_NAME="grainchainchannel"

#### CREATE CHANNEL ####
echo -e "\e[36m>======= CREATING CHANNEL ============>\e[0m"
peer channel create -c $GC_CHANNEL_NAME -f /var/hyperledger/config/grainchainchannel-channel.tx --outputBlock /var/hyperledger/config/grainchainchannel-0.block -o orderer1.grainchain.io:7050
#### JOIN THE CHANNEL ####
echo -e "\e[36m>======= JOINING peer $CORE_PEER_ADDRESS TO CHANNEL $GC_CHANNEL_NAME ============>\e[0m"
peer channel join -b /var/hyperledger/config/grainchainchannel-0.block
#### LIST CHANNELS ####
peer channel list

##GRAINCHAIN  PEER 2
export CORE_PEER_ADDRESS="peer2.grainchain.io:7051"
#### JOIN THE CHANNEL ####
echo -e "\e[36m>======= JOINING peer $CORE_PEER_ADDRESS TO CHANNEL $GC_CHANNEL_NAME ============>\e[0m"
peer channel join -b /var/hyperledger/config/grainchainchannel-0.block
#### LIST CHANNELS ####
peer channel list

#### UPDATE ANCHOR PEER ####
echo -e "\e[36m>======= UPDATING ANCHOR PEER ON Grainchain ORG ============>\e[0m"
configtxgen -outputAnchorPeersUpdate /var/hyperledger/config/config/peer-update.tx   -asOrg Grainchain -channelID $GC_CHANNEL_NAME  -profile GrainchainChannel
#### SUBMIT ANCHOR PEER UPDATE TX ####
peer channel update -f /var/hyperledger/config/config/peer-update.tx -c grainchainchannel -o orderer1.grainchain.io:7050

#Second ORG PEERS
cd /var/hyperledger/config
##COMMODITY  PEER 1
export CORE_PEER_ADDRESS="peer1.commodity.io:7051"
export CORE_PEER_MSPCONFIGPATH="/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/commodity.io/users/Admin@commodity.io/msp"
#### JOIN THE CHANNEL ####
echo -e "\e[36m>======= JOINING peer $CORE_PEER_ADDRESS TO CHANNEL $GC_CHANNEL_NAME ============>\e[0m"
peer channel join -b /var/hyperledger/config/grainchainchannel-0.block
#### LIST CHANNELS ####
peer channel list

##COMMODITY  PEER 2
export CORE_PEER_ADDRESS="peer2.commodity.io:7051"
#### JOIN THE CHANNEL ####
echo -e "\e[36m>======= JOINING peer $CORE_PEER_ADDRESS TO CHANNEL $GC_CHANNEL_NAME ============>\e[0m"
peer channel join -b /var/hyperledger/config/grainchainchannel-0.block
#### LIST CHANNELS ####
peer channel list

#### UPDATE ANCHOR PEER ####
echo -e "\e[36m>======= UPDATING ANCHOR PEER ON Commodity ORG ============>\e[0m"
configtxgen -outputAnchorPeersUpdate /var/hyperledger/config/config/peer-update.tx   -asOrg Commodity -channelID $GC_CHANNEL_NAME  -profile GrainchainChannel
#### SUBMIT ANCHOR PEER UPDATE TX ####
peer channel update -f /var/hyperledger/config/config/peer-update.tx -c grainchainchannel -o orderer1.grainchain.io:7050
