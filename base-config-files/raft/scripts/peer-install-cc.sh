#INSTALL CHAINCODE
##Mount on "/tmp/hyperledger/org" tools container the org msp folder "/vagrant/ca/client/peerOrganizations/commodity"
export CORE_PEER_ADDRESS=$1 #export CORE_PEER_ADDRESS=peer1-harvx.grainchain.io:7051
export CC_CHANNEL_ID=$2 # Channel name export CC_CHANNEL_ID="grainchainchannel"
export CORE_PEER_MSPCONFIGPATH="/tmp/hyperledger/org/users/admin/msp"  #admin msp dir, mounted on tools container /tmp/hyperledger/org/admin/msp
export CC2_PACKAGE_FOLDER="$PWD/packages"
export PACKAGE_NAME="gcnodecct"
export CC_PATH="/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/gc_node_granular_dac"
export CC_VERSION="1.0"
export CC_LANGUAGE="node"
export CC_CONSTRUCTOR='{"Args":[]}'
export CC_NAME="gcnodecc"
export CC_VERSION="1.0"
export INTERNAL_DEV_VERSION="1.0"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"
export ORDERER_ADDRESS=orderer1.grainchain.io:7050
export TLS_PARAMETERS="--tls"
export TLS_CA_CERT="/tmp/hyperledger/org/msp/tlscacerts/ca-cert.pem" #tls-ca-cert folder "/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem" 
export CORE_PEER_TLS_ENABLED=true

export CC_LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"

peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME
sleep 20

peer lifecycle chaincode queryinstalled

peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["getTruck","001"]}' $TLS_PARAMETERS --cafile $TLS_CA_CERT