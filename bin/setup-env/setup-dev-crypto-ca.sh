#!/bin/bash
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #

#DEFINE CONSTS
export GC_USER_PASSWORD="gc2020bc"
export GC_ORDERER_ORG_NAME="orderer"
export GC_PEER_ORG1="harvx"
export GC_PEER_ORG2="commodity"
export GC_PEER_ORG3="silosys"
export GC_TLS_ENABLED="false"
export GC_ORDERERS_COUNT=3
export GC_PEERS_COUNT=4

#IMPORTS
. /vagrant/bin/utils/loging.sh


#1 Create Orderer Admin and orderers
i=0
for (( i=0; i <= $GC_ORDERERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        /vagrant/bin/add-gc-user.sh Admin admin $GC_USER_PASSWORD $GC_ORDERER_ORG_NAME $GC_TLS_ENABLED
    else
        /vagrant/bin/add-gc-user.sh orderer$i orderer $GC_USER_PASSWORD $GC_ORDERER_ORG_NAME tls
    fi
done

#2 Create GC_PEER_ORG1 Admin and peers [ORG1]
i=0
for (( i=0; i <= $GC_PEERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        /vagrant/bin/add-gc-user.sh Admin admin $GC_USER_PASSWORD $GC_PEER_ORG1 $GC_TLS_ENABLED
    else
        /vagrant/bin/add-gc-user.sh peer$i peer $GC_USER_PASSWORD $GC_PEER_ORG1 tls
    fi
done

#3 Create GC_PEER_ORG2 Admin and peers [ORG2]
i=0
for (( i=0; i <= $GC_PEERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        /vagrant/bin/add-gc-user.sh Admin admin $GC_USER_PASSWORD $GC_PEER_ORG2 $GC_TLS_ENABLED
    else
        /vagrant/bin/add-gc-user.sh peer$i peer $GC_USER_PASSWORD $GC_PEER_ORG2 tls
    fi
done

#3.1 Create GC_PEER_ORG3 Admin and peers [ORG3]
i=0
for (( i=0; i <= $GC_PEERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        /vagrant/bin/add-gc-user.sh Admin admin $GC_USER_PASSWORD $GC_PEER_ORG3 $GC_TLS_ENABLED
    else
        /vagrant/bin/add-gc-user.sh peer$i peer $GC_USER_PASSWORD $GC_PEER_ORG3 tls
    fi
done

#4 List all identity created
export FABRIC_CA_CLIENT_HOME=$PWD/tmpcaadmin
mkdir tmpcaadmin
cd tmpcaadmin
echo $FABRIC_CA_ADMIN_CLIENT_HOME
if [ $GC_TLS_ENABLED == "true" ] 
then
    __msg_info "TLS IS ENABLED"
    fabric-ca-client enroll -u https://admin:$GC_USER_PASSWORD@localhost:7054 --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
    fabric-ca-client identity list --tls.certfiles /vagrant/ca/server/config/tls-docke.pem
else
    fabric-ca-client enroll -u http://admin:$GC_USER_PASSWORD@localhost:7054
    fabric-ca-client identity list
fi

##rm -rf $FABRIC_CA_CLIENT_HOME
mkdir -p /vagrant/ca/client/config/crypto-config
rm -rf /vagrant/ca/client
mkdir -p /vagrant/ca/client/config
cp -r /vagrant/config/crypto-config /vagrant/ca/client/config
rm -rf /vagrant/config/crypto-config