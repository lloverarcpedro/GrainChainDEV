#CLEAN

docker rm $(docker stop $(docker ps -aq))
docker volume rm $(docker volume list -q)
docker network prune --force


rm -rf /vagrant/tmp/hyperledger/tls-ca/crypto/*
rm -rf /vagrant/tmp/hyperledger/org0-ca/crypto/*
rm -rf /vagrant/tmp/hyperledger/org1-ca/crypto/*
rm -rf /vagrant/tmp/hyperledger/org2-ca/crypto/*
rm -rf /vagrant/tmp/hyperledger/tls-ca/admin/*
rm -rf /vagrant/tmp/hyperledger/org0-ca/admin/*
rm -rf /vagrant/tmp/hyperledger/org1-ca/admin/*
rm -rf /vagrant/tmp/hyperledger/org2-ca/admin/*

cd /vagrant/tmp/hyperledger
find . -iname "*.yaml" -exec rm -rf {} \;
find . -iname "*.pem" -exec rm -rf {} \;
find . -iname "*_sk" -exec rm -rf {} \;
find . -iname "Issuer*" -exec rm -rf {} \;
find . -iname "*.tx" -exec rm -rf {} \;
find . -iname "*.block" -exec rm -rf {} \;
cd /vagrant


#UP ALL CA SERVERS
docker-compose -f /vagrant/tmp/yamls/ca/root-ca.yaml up -d
sleep 5
docker-compose -f /vagrant/tmp/yamls/ca/org0-ca.yaml up -d
sleep 5
docker-compose -f /vagrant/tmp/yamls/ca/org1-ca.yaml up -d
sleep 5
docker-compose -f /vagrant/tmp/yamls/ca/org2-ca.yaml up -d
sleep 5


#REGISTER ALL USERS ON TLS CA
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem 
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/tls-ca/admin
fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer2-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer3-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer4-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer5-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052



export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem 
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0-ca/admin
fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminpw@0.0.0.0:7053 
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer2-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer3-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer4-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name orderer5-org0 --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name admin-org0 --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053


export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1-ca/crypto/ca-cert.pem 
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org1-ca/admin


fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminpw@0.0.0.0:7054 
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org1 --id.secret org1AdminPW --id.type user -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name user-org1 --id.secret org1UserPW --id.type user -u https://0.0.0.0:7054



export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2-ca/crypto/ca-cert.pem 
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org2-ca/admin
fabric-ca-client enroll -d -u https://rca-org2-admin:rca-org2-adminpw@0.0.0.0:7055 
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type user -u https://0.0.0.0:7055
fabric-ca-client register -d --id.name user-org2 --id.secret org2UserPW --id.type user -u https://0.0.0.0:7055



#ORG1 PEER ENROLL 
#Regular Enroll
cp /vagrant/tmp/hyperledger/org1-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/peer1/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org1/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1/peer1/assets/ca/ca-cert.pem -> copied previously
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7054

#TLS ENROLL
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem 
fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org1

#Regular Enroll PEER 2 ORG1
cp /vagrant/tmp/hyperledger/org1-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/peer2/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org1/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1/peer2/assets/ca/ca-cert.pem -> copied previously
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7054

#TLS ENROLL
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem 
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org1


#ORG1 ADMIN ENROLL
Regular Enroll
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org1/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org1/peer2/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054

mkdir /vagrant/tmp/hyperledger/org1/peer1/msp/admincerts
mkdir /vagrant/tmp/hyperledger/org1/peer2/msp/admincerts
cp /vagrant/tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem
cp /vagrant/tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org1/peer2/msp/admincerts/org1-admin-cert.pem




#ORG2 PEER ENROLL 
#Regular Enroll
cp /vagrant/tmp/hyperledger/org2-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/peer1/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org2/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2/peer1/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7055

#TLS ENROLL
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem 
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1-org2

#ORG2 PEER ENROLL 
#Regular Enroll
cp /vagrant/tmp/hyperledger/org2-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/peer2/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org2/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2/peer2/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7055

#TLS ENROLL
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/peer2/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer2-org2


#ORG2 ADMIN ENROLL
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org2/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org2/peer1/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7055


mkdir /vagrant/tmp/hyperledger/org2/peer1/msp/admincerts
mkdir /vagrant/tmp/hyperledger/org2/peer2/msp/admincerts
cp /vagrant/tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org2/peer1/msp/admincerts/org2-admin-cert.pem
cp /vagrant/tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org2/peer2/msp/admincerts/org2-admin-cert.pem
