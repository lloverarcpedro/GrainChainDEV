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

##### Create GENESIS BLOCK####
configtxgen -outputBlock /var/hyperledger/config/grainchainchannel-genesis.block -channelID ordererschannel -profile GrainchainOrdererGenesis -configPath /var/hyperledger/config

##### Create peer tx####
configtxgen -outputCreateChannelTx /var/hyperledger/config/grainchainchannel-channel.tx -channelID grainchainchannel -profile GrainchainChannel -configPath /var/hyperledger/config