#!/bin/bash
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #

#IMPORTS
. /vagrant/bin/utils/loging.sh

export GC_USER_PASSWORD="gc2020bc"
export GC_ORDERER_ORG_NAME="orderer"
export GC_PEER_ORG1="harvx"
export GC_PEER_ORG2="commodity"
export GC_TLS_ENABLED="false"
export GC_ORDERERS_COUNT=3
export GC_PEERS_COUNT=4 

#echo consts
__msg_info $GC_USER_PASSWORD
__msg_info $GC_ORDERER_ORG_NAME
__msg_info $GC_PEER_ORG1
__msg_info $GC_PEER_ORG2
__msg_info $GC_TLS_ENABLED
__msg_info $GC_ORDERERS_COUNT
__msg_info $GC_PEERS_COUNT


# ENROLL AS CA ADMIN
export FABRIC_CA_CLIENT_HOME=$PWD/tmpcaadmin
cd tmpcaadmin
if [ $GC_TLS_ENABLED == "true" ] 
then
    __msg_info "TLS IS ENABLED"
    fabric-ca-client enroll -u https://admingc:$GC_USER_PASSWORD@localhost:7054 --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
    fabric-ca-client identity list --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
else
    fabric-ca-client enroll -u http://admingc:$GC_USER_PASSWORD@localhost:7054
    fabric-ca-client identity list
fi

#REMOVE ALL ORDERERS FROM CA
i=0
for (( i=0; i <= $GC_ORDERERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        __msg_info "DELETING Admin@$GC_ORDERER_ORG_NAME.io"
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove Admin@$GC_ORDERER_ORG_NAME.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
        else
            fabric-ca-client identity remove Admin@$GC_ORDERER_ORG_NAME.io
        fi
    else
        __msg_info "DELETING orderer$i@$GC_ORDERER_ORG_NAME.io"  
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove orderer$i@$GC_ORDERER_ORG_NAME.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem  
        else
            fabric-ca-client identity remove orderer$i@$GC_ORDERER_ORG_NAME.io
        fi
    fi
done

#REMOVE ALL ORG1 PEERS FROM CA
i=0
for (( i=0; i <= $GC_PEERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        __msg_info "DELETING Admin@$GC_PEER_ORG1.io"
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove Admin@$GC_PEER_ORG1.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
        else
            fabric-ca-client identity remove Admin@$GC_PEER_ORG1.io
        fi
    else
        __msg_info "DELETING peer$i@$GC_PEER_ORG1.io"  
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove peer$i@$GC_PEER_ORG1.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem  
        else
            fabric-ca-client identity remove peer$i@$GC_PEER_ORG1.io
        fi
    fi
done
#REMOVE ALL ORG2 PEERS FROM CA
i=0
for (( i=0; i <= $GC_PEERS_COUNT; ++i ))
do
    if [ $i == 0 ]
    then
        __msg_info "DELETING Admin@$GC_PEER_ORG2.io"
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove Admin@$GC_PEER_ORG2.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
        else
            fabric-ca-client identity remove Admin@$GC_PEER_ORG2.io
        fi
    else
        __msg_info "DELETING peer$i@$GC_PEER_ORG2.io"  
        if [ $GC_TLS_ENABLED == "true" ]
        then
            fabric-ca-client identity remove peer$i@$GC_PEER_ORG2.io --tls.certfiles /vagrant/ca/server/config/tls-cert.pem  
        else
            fabric-ca-client identity remove peer$i@$GC_PEER_ORG2.io
        fi
    fi
done

# LIST IDENTITIES
export FABRIC_CA_CLIENT_HOME=$PWD/tmpcaadmin
cd tmpcaadmin
if [ $GC_TLS_ENABLED == "true" ] 
then
    __msg_info "TLS IS ENABLED"
    fabric-ca-client enroll -u https://admingc:$GC_USER_PASSWORD@localhost:7054 --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
    fabric-ca-client identity list --tls.certfiles /vagrant/ca/server/config/tls-cert.pem
else
    fabric-ca-client enroll -u http://admingc:$GC_USER_PASSWORD@localhost:7054
    fabric-ca-client identity list
fi

exit 0