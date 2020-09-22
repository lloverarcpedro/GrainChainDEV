###--- ADD org MSP ---### 

#Imports 
. /vagrant/bin/utils/loging.sh

# set -o errexit
# set -o nounset
# set -o pipefail

function usage {
    __msg_help    "Creates the admincerts folder and copies the admin's cert to admincerts folder"
    __msg_help    "Usage:    ./create-genesis.sh <CHANNEL-ID>"
    
}

#1. Validate Inputs
if [ -z $1 ]
then
    __msg_error "Please provide CHANNEL-ID"
    usage
    exit 0
else 
    if [ $1 == "-h" ] || [ $1 == "-help" ]
    then
        usage
        exit 0
    else

        #2. Set Constants
        CHANNEL_ID=$1
        export GC_CHANNEL_ID=$CHANNEL_PROFILE
        OUTPUT_BLOCK="/vagrant/config/$CHANNEL_ID-genesis.block"
        BLOCK_PROFILE="GrainchainOrdererGenesis"
        OUTPUT_CHANNEL_TX="/vagrant/config/$CHANNEL_ID-channel.tx" 
        CHANNEL_PROFILE="GrainchainChannel"
        CONFIG_PATH="/vagrant/config"
    fi
fi



#2.1 erase previous blocks and tx files 
rm -rf /vagrant/peer/config/*.block
rm -rf /vagrant/orderer/config/*.block
rm -rf /vagrant/config/*.block
rm -rf /vagrant/config/*.tx
rm -rf /vagrant/peer/config/*.tx
rm -rf /vagrant/orderer/config/*.tx

#3. Creates Orderer Genesis Block
configtxgen -outputBlock $OUTPUT_BLOCK -channelID ordererschannel -profile $BLOCK_PROFILE -configPath $CONFIG_PATH
CREATE_BLOCK = configtxgen -inspectBlock $OUTPUT_BLOCK
__msg_info $CREATE_BLOCK

#4. Create Channel TX
configtxgen -outputCreateChannelTx $OUTPUT_CHANNEL_TX -channelID $CHANNEL_ID -profile $CHANNEL_PROFILE -configPath $CONFIG_PATH
CREATE_TX= configtxgen -inspectChannelCreateTx $OUTPUT_CHANNEL_TX
__msg_info $CREATE_TX

#5. Copy TX file to peer config 
cp $OUTPUT_CHANNEL_TX /vagrant/peer/config
cp $OUTPUT_CHANNEL_TX /vagrant/orderer/config
__msg_info "=====> TX file $OUTPUT_CHANNEL_TX copied to: peer/config folder"

#6. copy Genesis Block to peer config
cp $OUTPUT_BLOCK /vagrant/peer/config
cp $OUTPUT_BLOCK /vagrant/orderer/config
__msg_info "=====> Genesis Block file $OUTPUT_BLOCK copied to: peer/config folder"

exit 0