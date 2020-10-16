#!/bin/bash
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #
cd /var/hyperledger/config
export MSP_ID=GrainchainMSP
export ORG_NAME=GrainchainMSP
export CORE_PEER_LOCALMSPID=GrainchainMSP
export CORE_PEER_ADDRESS="peer2.grainchain.io:8051"
export ORDERER_ADDRESS="orderer1.grainchain.io:7050"
export CORE_PEER_MSPCONFIGPATH="/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/harvx.io/users/Admin@harvx.io/msp"
export GC_PEER_ORG1=2
export GC_PEER_ORG2=3
export GC_PEER_ORG3=2
export GC_ORG_NAME="grainchain"
########################################################
export GC_PDC_ENABLED=$1
echo "=========================> PDC VALUE : $GC_PDC_ENABLED <========================="
source ./vagrant/setup/tool-bins/set-context.sh grainchain

#Install chaincode for ORG1
for (( i=1; i <= $GC_PEER_ORG1; ++i ))
do
    export CORE_PEER_ADDRESS="peer$i.$GC_ORG_NAME.io:7051"
    echo "---- Installing chaincode on $CORE_PEER_ADDRESS <-----"
    ./vagrant/setup/tool-bins/cc-test.sh install $GC_PDC_ENABLED
    sleep 5
    ./vagrant/setup/tool-bins/cc-test.sh instantiate $GC_PDC_ENABLED
done

#Install chaincode for ORG2
export GC_ORG_NAME="commodity"
export CORE_PEER_MSPCONFIGPATH="/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/commodity.io/users/Admin@commodity.io/msp"

for (( i=1; i <= $GC_PEER_ORG2; ++i ))
do
    export CORE_PEER_ADDRESS="peer$i.$GC_ORG_NAME.io:7051"
    echo "-----> Installing chaincode on $CORE_PEER_ADDRESS <-----"
    ./vagrant/setup/tool-bins/cc-test.sh install $GC_PDC_ENABLED
    sleep 5
    ./vagrant/setup/tool-bins/cc-test.sh instantiate $GC_PDC_ENABLED
done

#Install chaincode for ORG3
export GC_ORG_NAME="silosys" \
export CORE_PEER_MSPCONFIGPATH="/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/silosys.io/users/Admin@silosys.io/msp"
for (( i=1; i <= $GC_PEER_ORG3; ++i ))
do
    export CORE_PEER_ADDRESS="peer$i.$GC_ORG_NAME.io:7051"
    echo "-----> Installing chaincode on $CORE_PEER_ADDRESS <-----"
    ./vagrant/setup/tool-bins/cc-test.sh install $GC_PDC_ENABLED
    sleep 5
    ./vagrant/setup/tool-bins/cc-test.sh instantiate $GC_PDC_ENABLED
done

export CORE_PEER_ADDRESS="peer1.grainchain.io:7051"
echo "----- Sleep 15 seconds before invoke -----"
sleep 15
./vagrant/setup/tool-bins/cc-test.sh invoke 

export CORE_PEER_ADDRESS="peer1.commodity.io:7051"
echo "----- Sleep 15 seconds before query -----"
sleep 15
# ./vagrant/setup/tool-bins/cc-test.sh invoke
 ./vagrant/setup/tool-bins/cc-test.sh query