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


#### CREATE CHANNEL ####
peer channel create -c grainchainchannel -f /var/hyperledger/config/grainchainchannel-channel.tx --outputBlock /var/hyperledger/config/grainchainchannel-0.block -o orderer1.grainchain.io:7050
#### JOIN THE CHANNEL ####
peer channel join -b /var/hyperledger/config/grainchainchannel-0.block
#### LIST CHANNELS ####
peer channel list

#### UPDATE ANCHOR PEER ####
configtxgen -outputAnchorPeersUpdate /var/hyperledger/config/config/peer-update.tx   -asOrg Grainchain -channelID grainchainchannel  -profile GrainchainChannel
#### SUBMIT ANCHOR PEER UPDATE TX ####
peer channel update -f /var/hyperledger/config/config/peer-update.tx -c grainchainchannel -o orderer1.grainchain.io:7050