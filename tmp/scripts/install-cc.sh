#INSTALL CHAINCODE
#ORG1 PEER 1
docker exec -it cli-org1 sh
export CORE_PEER_ADDRESS=peer2-org2:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp


export CC2_PACKAGE_FOLDER="$PWD/packages"
export PACKAGE_NAME="gcnodecct"
export CC_PATH="/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/gc_node_granular_dac"
export CC_VERSION="2.0"
export CC_LANGUAGE="node"
export CC_CONSTRUCTOR='{"Args":[]}'

export CC_NAME="gcnodecc"
export CC_VERSION="1.0"
export INTERNAL_DEV_VERSION="2.0"


export CC_LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"

mkdir packages

peer lifecycle chaincode package $CC2_PACKAGE_FOLDER/$PACKAGE_NAME -p $CC_PATH --label=$CC_LABEL -l $CC_LANGUAGE

peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME

peer lifecycle chaincode queryinstalled

export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp
export CORE_PEER_ADDRESS=peer1-org2:7051
export CC_CHANNEL_ID="mychannel"
export PACKAGE_ID="gcnodecc.1.0-2.0:c5b63cdd59151b4b81d524713eab902156d3502c1175566e1ed510a6de9466de"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"
export ORDERER_ADDRESS=orderer3-org0:7050
export TLS_PARAMETERS="--tls"
export TLS_CA_CERT="/tmp/hyperledger/org2/peer1/assets/tls-ca/tls-ca-cert.pem" 
export CORE_PEER_TLS_ENABLED=true

peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE $CC2_INIT_REQUIRED -o $ORDERER_ADDRESS $TLS_PARAMETERS --waitForEvent --cafile $TLS_CA_CERT


#### INSTANTIATE ###
peer lifecycle chaincode commit -C $CC_CHANNEL_ID -n $CC_NAME -v $CC_VERSION \
                --sequence $CC2_SEQUENCE  $CC2_INIT_REQUIRED    --waitForEvent \
                --tls --cafile $TLS_CA_CERT

### INIT CHAINCODE ###
peer chaincode invoke  -C $CC_CHANNEL_ID -n $CC_NAME -c $CC_CONSTRUCTOR --isInit --waitForEvent -o $ORDERER_ADDRESS --tls --cafile $TLS_CA_CERT

peer chaincode invoke -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["addTruck","001","DINA","MODELA43","2021","RED"]}' --tls --cafile $TLS_CA_CERT


peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["getTruck","001"]}' --tls --cafile $TLS_CA_CERT