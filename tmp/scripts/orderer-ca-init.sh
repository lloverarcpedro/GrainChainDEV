#ORDERES SETUP
#Orderer 1
mkdir -p /vagrant/tmp/hyperledger/org0/orderer1/assets/ca/
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer1/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer1/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7053

mkdir -p /vagrant/tmp/hyperledger/org0/orderer1/assets/tls-ca/
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer1/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer1/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0

#Orderer 2
mkdir -p /vagrant/tmp/hyperledger/org0/orderer2/assets/ca/
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer2/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer2/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer2-org0:ordererpw@0.0.0.0:7053

mkdir -p /vagrant/tmp/hyperledger/org0/orderer2/assets/tls-ca/
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer2/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer2-org0


#Orderer 3
mkdir -p /vagrant/tmp/hyperledger/org0/orderer3/assets/ca/
mkdir -p /vagrant/tmp/hyperledger/org0/orderer3/assets/tls-ca/
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer3/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer3/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer3-org0:ordererpw@0.0.0.0:7053

cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer3/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer3/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer3-org0


#Orderer 4
mkdir -p /vagrant/tmp/hyperledger/org0/orderer4/assets/ca/
mkdir -p /vagrant/tmp/hyperledger/org0/orderer4/assets/tls-ca/
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer4/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer4/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer4-org0:ordererpw@0.0.0.0:7053

cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer4/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer4/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer4-org0


#Orderer 5
mkdir -p /vagrant/tmp/hyperledger/org0/orderer5/assets/ca/
mkdir -p /vagrant/tmp/hyperledger/org0/orderer5/assets/tls-ca/
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer5/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer5
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer5/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer5-org0:ordererpw@0.0.0.0:7053

cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer5/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer5/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer5-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer5-org0


#ORDERES ADMIN
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer1/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org0:org0adminpw@0.0.0.0:7053

mkdir /vagrant/tmp/hyperledger/org0/orderer1/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer1/msp/admincerts/orderer-admin-cert.pem

mkdir /vagrant/tmp/hyperledger/org0/orderer2/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer2/msp/admincerts/orderer-admin-cert.pem

mkdir /vagrant/tmp/hyperledger/org0/orderer3/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer3/msp/admincerts/orderer-admin-cert.pem

mkdir /vagrant/tmp/hyperledger/org0/orderer4/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer4/msp/admincerts/orderer-admin-cert.pem

mkdir /vagrant/tmp/hyperledger/org0/orderer5/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer5/msp/admincerts/orderer-admin-cert.pem


#SETUP ORGS MPS
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/msp/tlscacerts
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/msp/tlscacerts
cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/msp/tlscacerts

cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/msp/cacerts
cp /vagrant/tmp/hyperledger/org1-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org1/msp/cacerts
cp /vagrant/tmp/hyperledger/org2-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org2/msp/cacerts

cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/msp/admincerts
cp /vagrant/tmp/hyperledger/org1/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org1/msp/admincerts
cp /vagrant/tmp/hyperledger/org2/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org2/msp/admincerts


#RENAME KEYSTORE FILES
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer1/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer1/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer1/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer1/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer1/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer1/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer2/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer2/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer2/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer2/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer2/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer2/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer3/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer3/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer3/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer3/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer3/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer3/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer4/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer4/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer4/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer4/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer4/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer4/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer5/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer5/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer5/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer5/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer5/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer5/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org1/peer1/msp/keystore/)
mv /vagrant/tmp/hyperledger/org1/peer1/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org1/peer1/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org1/peer1/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org1/peer1/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org1/peer1/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org1/peer2/msp/keystore/)
mv /vagrant/tmp/hyperledger/org1/peer2/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org1/peer2/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org1/peer2/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org1/peer2/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org1/peer2/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org1/admin/msp/keystore/)
mv /vagrant/tmp/hyperledger/org1/admin/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org1/admin/msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org2/peer1/msp/keystore/)
mv /vagrant/tmp/hyperledger/org2/peer1/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org2/peer1/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org2/peer1/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org2/peer1/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org2/peer1/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org2/peer2/msp/keystore/)
mv /vagrant/tmp/hyperledger/org2/peer2/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org2/peer2/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org2/peer2/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org2/peer2/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org2/peer2/tls-msp/keystore/key.pem

KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org2/admin/msp/keystore/)
mv /vagrant/tmp/hyperledger/org2/admin/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org2/admin/msp/keystore/key.pem
