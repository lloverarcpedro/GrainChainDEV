#ORDERES SETUP
cp /vagrant/tmp/hyperledger/org0-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer/assets/ca/
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer/assets/ca/ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@0.0.0.0:7053

cp /vagrant/tmp/hyperledger/tls-ca/crypto/ca-cert.pem /vagrant/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0

#ORDERES ADMIN
export FABRIC_CA_CLIENT_HOME=/vagrant/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/vagrant/tmp/hyperledger/org0/orderer/assets/ca/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org0:org0adminpw@0.0.0.0:7053

mkdir /vagrant/tmp/hyperledger/org0/orderer/msp/admincerts
cp /vagrant/tmp/hyperledger/org0/admin/msp/signcerts/cert.pem /vagrant/tmp/hyperledger/org0/orderer/msp/admincerts/orderer-admin-cert.pem


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
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer/msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer/msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer/msp/keystore/key.pem
KEYSTORE_FILE=$(ls /vagrant/tmp/hyperledger/org0/orderer/tls-msp/keystore/)
mv /vagrant/tmp/hyperledger/org0/orderer/tls-msp/keystore/$KEYSTORE_FILE /vagrant/tmp/hyperledger/org0/orderer/tls-msp/keystore/key.pem

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