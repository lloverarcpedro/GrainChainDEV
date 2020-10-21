#Imports 
. /vagrant/bin/utils/loging.sh

#CONSTS
export GC_COMMODITY_PEER_COUNT=5
export GC_HARVX_PEER_COUNT=5
export GC_ORDERERS_COUNT=5
#Clean and delete previous run.
#Clean containers
docker rm $(docker stop $(docker ps -aq))
docker volume rm $(docker volume list -q)
docker network prune --force
#Clean CA-servers folders and dabases
rm -rf /vagrant/ca/server/tls-ca/crypto/*
sudo rm -rf /opt/shared_storage/tls-ca_db_data_postgre
sudo mkdir -p /opt/shared_storage/tls-ca_db_data_postgre
sudo chmod 777 /opt/shared_storage/tls-ca_db_data_postgre

rm -rf /vagrant/ca/server/orderers-ca/crypto/*
sudo rm -rf /opt/shared_storage/orderers-ca_db_data_postgre
sudo mkdir -p /opt/shared_storage/orderers-ca_db_data_postgre
sudo chmod 777 /opt/shared_storage/orderers-ca_db_data_postgre

rm -rf /vagrant/ca/server/harvx-ca/crypto/*
sudo rm -rf /opt/shared_storage/harvx-ca_db_data_postgre
sudo mkdir -p /opt/shared_storage/harvx-ca_db_data_postgre
sudo chmod 777 /opt/shared_storage/harvx-ca_db_data_postgre

rm -rf /vagrant/ca/server/commodity-ca/crypto/*
sudo rm -rf /opt/shared_storage/commodity-ca_db_data_postgre
sudo mkdir -p /opt/shared_storage/commodity-ca_db_data_postgre
sudo chmod 777 /opt/shared_storage/commodity-ca_db_data_postgre

#Clean previous ca enrollments inside ca/client folder
find ./ca/client -iname "*_sk" -exec rm -rf {} \;
find ./ca/client -iname "*.pem" -exec rm -rf {} \;
find ./ca/client -iname "*Key" -exec rm -rf {} \;
find ./ca/client -iname "*.yaml" -exec rm -rf {} \;
rm -rf /vagrant/ca/client/peerOrganizations/harvx/*
rm -rf /vagrant/ca/client/peerOrganizations/commodity/*
rm -rf /vagrant/ca/client/ordererOrganizations/orderers/*

#Copy ca-servers config files
cp /vagrant/base-config-files/raft/ca/fabric-tls-ca-server-config.yaml /vagrant/ca/server/tls-ca/crypto/fabric-ca-server-config.yaml
cp /vagrant/base-config-files/raft/ca/fabric-orderers-ca-server-config.yaml /vagrant/ca/server/orderers-ca/crypto/fabric-ca-server-config.yaml
cp /vagrant/base-config-files/raft/ca/fabric-harvx-ca-server-config.yaml /vagrant/ca/server/harvx-ca/crypto/fabric-ca-server-config.yaml
cp /vagrant/base-config-files/raft/ca/fabric-commodity-ca-server-config.yaml /vagrant/ca/server/commodity-ca/crypto/fabric-ca-server-config.yaml

#Start CA containers one by one
__msg_info "ca-databases docker-compose up"
docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d tls-cert-auth-db.grainchain.io
docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d orderers-cert-auth-db.grainchain.io
docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d harvx-cert-auth-db.grainchain.io
docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d commodity-cert-auth-db.grainchain.io
__msg_info "Sleeping 20 seconds before ca-servers up"
sleep 20

i=0
while
    __msg_info "HarvX CA up Number: $i"
    : ${start=$i}              # capture the starting value of i
    # some other commands      # needed for the loop
    docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d harvx-cert-auth.grainchain.io
    sleep 20
    RISED=$(docker ps | grep "harvx-cert-auth.grainchain.io" | wc -l)
    if [ $RISED == 0 ]
    then
        __msg_error "HarvX CA Error try number $i"
    fi
    (( ++i < 3  && $RISED == 0 ))          # Place the loop ending test here.
do :; done

i=0
while
    echo "Commodity CA try Number: $i"
    : ${start=$i}              # capture the starting value of i
    # some other commands      # needed for the loop
    docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d commodity-cert-auth.grainchain.io
    sleep 20
    RISED=$(docker ps | grep "commodity-cert-auth.grainchain.io" | wc -l)
    if [ $RISED == 0 ]
    then
        __msg_error "Commodity CA Error try number $i"
    fi
    (( ++i < 3  && $RISED == 0 ))            # Place the loop ending test here.
do :; done
i=0
while
    echo "TLS CA try Number: $i"
    : ${start=$i}              # capture the starting value of i
    # some other commands      # needed for the loop
    docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d tls-cert-auth.grainchain.io
    sleep 20
    RISED=$(docker ps | grep "tls-cert-auth.grainchain.io" | wc -l)
    if [ $RISED == 0 ]
    then
        __msg_error "TLS CA Error try number $i"
    fi
    (( ++i < 3  && $RISED == 0 ))            # Place the loop ending test here.
do :; done
i=0
while
    __msg_info "Orderers CA try Number: $i"
    : ${start=$i}              # capture the starting value of i
    # some other commands      # needed for the loop
    docker-compose -f /vagrant/base-config-files/raft/ca/docker-compose-ca.yaml up -d orderers-cert-auth.grainchain.io
    sleep 20
    RISED=$(docker ps | grep "orderers-cert-auth.grainchain.io" | wc -l)
    if [ $RISED == 0 ]
    then
        __msg_error "Orderers CA Error try number $i"
    fi
    (( ++i < 3  && $RISED == 0 ))           # Place the loop ending test here.
do :; done

__msg_info "Sleeping 20 seconds before enroll"
sleep 20


#ENROLLMENT

#Enroll ca admins
export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/tlsCA/users/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/tls-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://tls-ca-admin:gc2020bc@0.0.0.0:7052
#Rename private key
export GC_KEY_FILE=$(ls /vagrant/ca/client/tlsCA/users/admin/msp/keystore/)
mv /vagrant/ca/client/tlsCA/users/admin/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/tlsCA/users/admin/msp/keystore/key.pem
mkdir -p /vagrant/ca/client/tlsCA/users/admin/msp/admincerts
cp /vagrant/ca/client/tlsCA/users/admin/msp/signcerts/* /vagrant/ca/client/tlsCA/users/admin/msp/admincerts/*

export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/ordererOrganizations/orderers/users/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/orderers-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer-ca-admin:gc2020bc@0.0.0.0:7053
#Rename private key
export GC_KEY_FILE=$(ls /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/keystore/)
mv /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/keystore/key.pem
mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/admincerts
cp /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/signcerts/* /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/admincerts/*

export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/harvx/users/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/harvx-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://harvx-ca-admin:gc2020bc@0.0.0.0:7054
#Rename private key
export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/keystore/)
mv /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/keystore/key.pem
mkdir -p /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/admincerts
cp /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/signcerts/* /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/admincerts/*

export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/commodity/users/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/commodity-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://commodity-ca-admin:gc2020bc@0.0.0.0:7055
#Rename private key
export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/keystore/)
mv /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/keystore/key.pem
mkdir -p /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/admincerts
cp /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/signcerts/* /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/admincerts/*


export FABRIC_CA_CLIENT_MSPDIR=""
export GC_KEY_FILE=""

#Register orderer users and peer users
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/orderers-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/ordererOrganizations/orderers/users/admin
#Register Orderers Admin
fabric-ca-client register -d --id.name admin-orderer --id.secret gc2020bc --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053
#Register Orderers Identities
for (( i=1; i <= $GC_ORDERERS_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name orderer$i.grainchain.io --id.secret gc2020bc --id.type orderer -u https://0.0.0.0:7053
done

#Register harvx peer users
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/harvx-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/harvx/users/admin
#Register Harvx Admin
fabric-ca-client register -d --id.name admin-harvx --id.secret gc2020bc --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7054
#Register HarvX Peer Identities
for (( i=1; i <= $GC_HARVX_PEER_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name peer$i-harvx.grainchain.io --id.secret gc2020bc --id.type peer -u https://0.0.0.0:7054
done

#Register commodity peer users
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/commodity-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/commodity/users/admin
#Register Commodity Admin
fabric-ca-client register -d --id.name admin-commodity --id.secret gc2020bc --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7055
#Register Commodity peers identities
for (( i=1; i <= $GC_COMMODITY_PEER_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name peer$i-commodity.grainchain.io --id.secret gc2020bc --id.type peer -u https://0.0.0.0:7055
done


#Register all identities on tls server
export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/tlsCA/users/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/server/tls-ca/crypto/ca-cert.pem
for (( i=1; i <= $GC_ORDERERS_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name orderer$i.grainchain.io --id.secret gc2020bc --id.type orderer -u https://0.0.0.0:7052
done

for (( i=1; i <= $GC_HARVX_PEER_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name peer$i-harvx.grainchain.io --id.secret gc2020bc --id.type peer -u https://0.0.0.0:7052
done

for (( i=1; i <= $GC_COMMODITY_PEER_COUNT; ++i ))
do
    fabric-ca-client register -d --id.name peer$i-commodity.grainchain.io --id.secret gc2020bc --id.type peer -u https://0.0.0.0:7052
done


#Enroll orderer users
#Create ORG MSP
mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/msp/admincerts
cp /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/ordererOrganizations/orderers/msp/admincerts
mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/msp/cacerts
cp /vagrant/ca/server/orderers-ca/crypto/ca-cert.pem /vagrant/ca/client/ordererOrganizations/orderers/msp/cacerts
mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/msp/tlscacerts
cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/ordererOrganizations/orderers/msp/tlscacerts

for (( i=1; i <= $GC_ORDERERS_COUNT; ++i ))
do
    #MSP enroll
    mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/ca/
    cp /vagrant/ca/server/orderers-ca/crypto/ca-cert.pem /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/
    export FABRIC_CA_CLIENT_MSPDIR=msp
    fabric-ca-client enroll -d -u https://orderer$i.grainchain.io:gc2020bc@0.0.0.0:7053
    #copy admin cert
    mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/msp/admincerts
    cp /vagrant/ca/client/ordererOrganizations/orderers/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/msp/admincerts/
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/msp/keystore/)
    mv /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/msp/keystore/key.pem
    #TLS enroll
    mkdir -p /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/tls-ca/
    cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/tls-ca/ca-cert.pem
    export FABRIC_CA_CLIENT_MSPDIR=tls-msp
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/assets/tls-ca/ca-cert.pem
    fabric-ca-client enroll -d -u https://orderer$i.grainchain.io:gc2020bc@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer$i.grainchain.io
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/tls-msp/keystore/)
    mv /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/tls-msp/keystore/$GC_KEY_FILE /vagrant/ca/client/ordererOrganizations/orderers/orderers/orderer$i.grainchain.io/tls-msp/keystore/key.pem

done

#Enroll for  HarvX ORG
#Create ORG MSP
mkdir -p /vagrant/ca/client/peerOrganizations/harvx/msp/admincerts
cp /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/peerOrganizations/harvx/msp/admincerts
mkdir -p /vagrant/ca/client/peerOrganizations/harvx/msp/cacerts
cp /vagrant/ca/server/harvx-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/harvx/msp/cacerts
mkdir -p /vagrant/ca/client/peerOrganizations/harvx/msp/tlscacerts
cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/harvx/msp/tlscacerts

for (( i=1; i <= $GC_HARVX_PEER_COUNT; ++i ))
do
    #MSP enroll
    mkdir -p /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/ca/
    cp /vagrant/ca/server/harvx-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/
    export FABRIC_CA_CLIENT_MSPDIR=msp
    fabric-ca-client enroll -d -u https://peer$i-harvx.grainchain.io:gc2020bc@0.0.0.0:7054
    #copy admin cert
    mkdir -p /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/msp/admincerts
    cp /vagrant/ca/client/peerOrganizations/harvx/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/msp/admincerts/
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/msp/keystore/)
    mv /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/msp/keystore/key.pem
    #TLS enroll
    mkdir -p /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/tls-ca/
    cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/tls-ca/ca-cert.pem
    export FABRIC_CA_CLIENT_MSPDIR=tls-msp
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/assets/tls-ca/ca-cert.pem
    fabric-ca-client enroll -d -u https://peer$i-harvx.grainchain.io:gc2020bc@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer$i-harvx.grainchain.io
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/tls-msp/keystore/)
    mv /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/tls-msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/harvx/peers/peer$i-harvx.grainchain.io/tls-msp/keystore/key.pem

done

#Enroll for  Commodity ORG
#Create ORG MSP
mkdir -p /vagrant/ca/client/peerOrganizations/commodity/msp/admincerts
cp /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/peerOrganizations/commodity/msp/admincerts
mkdir -p /vagrant/ca/client/peerOrganizations/commodity/msp/cacerts
cp /vagrant/ca/server/commodity-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/commodity/msp/cacerts
mkdir -p /vagrant/ca/client/peerOrganizations/commodity/msp/tlscacerts
cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/commodity/msp/tlscacerts

for (( i=1; i <= $GC_COMMODITY_PEER_COUNT; ++i ))
do
    #MSP enroll
    mkdir -p /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/ca/
    cp /vagrant/ca/server/commodity-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/ca/ca-cert.pem
    export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/
    export FABRIC_CA_CLIENT_MSPDIR=msp
    fabric-ca-client enroll -d -u https://peer$i-commodity.grainchain.io:gc2020bc@0.0.0.0:7055
    #copy admin cert
    mkdir -p /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/msp/admincerts
    cp /vagrant/ca/client/peerOrganizations/commodity/users/admin/msp/signcerts/cert.pem /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/msp/admincerts/
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/msp/keystore/)
    mv /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/msp/keystore/key.pem
    #TLS enroll
    mkdir -p /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/tls-ca/
    cp /vagrant/ca/server/tls-ca/crypto/ca-cert.pem /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/tls-ca/ca-cert.pem
    export FABRIC_CA_CLIENT_MSPDIR=tls-msp
    export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/assets/tls-ca/ca-cert.pem
    fabric-ca-client enroll -d -u https://peer$i-commodity.grainchain.io:gc2020bc@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer$i-commodity.grainchain.io
    #Rename private key
    export GC_KEY_FILE=$(ls /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/tls-msp/keystore/)
    mv /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/tls-msp/keystore/$GC_KEY_FILE /vagrant/ca/client/peerOrganizations/commodity/peers/peer$i-commodity.grainchain.io/tls-msp/keystore/key.pem

done