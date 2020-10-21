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

export CC2_SEQUENCE=$3
export CC2_INIT_REQUIRED="--init-required"
export ORDERER_ADDRESS=orderer1.grainchain.io:7050
export TLS_PARAMETERS="--tls"
export TLS_CA_CERT="/tmp/hyperledger/org/msp/tlscacerts/ca-cert.pem" #tls-ca-cert folder "/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem" 
export CORE_PEER_TLS_ENABLED=true

export CC_LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"

# Extracts the package id from installed package
function cc_get_package_id {  
    export OUTPUT=$(peer lifecycle chaincode queryinstalled -O json)
    export PACKAGE_ID=$(echo $OUTPUT | jq -r ".installed_chaincodes[]|select(.label==\"$LABEL\")|.package_id") 
}

mkdir packages

peer lifecycle chaincode package $CC2_PACKAGE_FOLDER/$PACKAGE_NAME -p $CC_PATH --label=$CC_LABEL -l $CC_LANGUAGE
sleep 20 

peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME
sleep 20

peer lifecycle chaincode queryinstalled

cc_get_package_id

clear
echo "Before - PACKAGE ID:"
echo $PACKAGE_ID
export PACKAGE_ID="gcnodecc.1.0-1.0:99e3f5d191ea30ceb00241d857a35d679cf4ba770ee276547129d6b9f5e56061"
echo "After - PACKAGE ID:"
echo $PACKAGE_ID

peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE $CC2_INIT_REQUIRED -o $ORDERER_ADDRESS $TLS_PARAMETERS --waitForEvent --cafile $TLS_CA_CERT
sleep 30

#### INSTANTIATE ###
peer lifecycle chaincode commit -C $CC_CHANNEL_ID -n $CC_NAME -v $CC_VERSION \
                --sequence $CC2_SEQUENCE  $CC2_INIT_REQUIRED    --waitForEvent \
                --tls --cafile $TLS_CA_CERT
sleep 20

### INIT CHAINCODE ###
peer chaincode invoke  -C $CC_CHANNEL_ID -n $CC_NAME -c $CC_CONSTRUCTOR --isInit --waitForEvent -o $ORDERER_ADDRESS $TLS_PARAMETERS --cafile $TLS_CA_CERT
sleep 10

peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["addTruck","001","DINA","MODELA43","2021","RED"]}' $TLS_PARAMETERS --cafile $TLS_CA_CERT
sleep 10

peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["getTruck","001"]}' $TLS_PARAMETERS --cafile $TLS_CA_CERT