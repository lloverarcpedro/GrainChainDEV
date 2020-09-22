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

########################################################
source ./vagrant/setup/tool-bins/set-context.sh grainchain
./vagrant/setup/tool-bins/cc-test.sh install
echo "----- Sleep 20 seconds before init-----"
sleep 20
./vagrant/setup/tool-bins/cc-test.sh instantiate

echo "----- Sleep 15 seconds before invoke -----"
sleep 15
./vagrant/setup/tool-bins/cc-test.sh invoke

echo "----- Sleep 15 seconds before query -----"
sleep 15
# ./vagrant/setup/tool-bins/cc-test.sh invoke
 ./vagrant/setup/tool-bins/cc-test.sh query