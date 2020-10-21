#Imports 
. /vagrant/bin/utils/loging.sh

#CONSTS
export GC_ORDERERS_COUNT=5
export GC_HARVX_PEERS_COUNT=5
export GC_COMMODITY_PEERS_COUNT=5


#Clean config folder
rm -rf /vagrant/config/*
#Clean Orderers Folder
rm -rf /vagrant/orderer/*
#clean Peers folder
rm -rf /vagrant/peer/*

#Copy configtx
cp /vagrant/base-config-files/raft/configtx/configtx.yaml /vagrant/config/
#Create genesis block and tx
cd /vagrant/config/
configtxgen -profile OrgsOrdererGenesis -outputBlock ./genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx ./channel.tx -channelID grainchainchannel
cd /vagrant/

### Genesis Block Created?
GEN_FILE_CREATED=$(ls /vagrant/config/genesis.block | wc -l)
if [ $GEN_FILE_CREATED -lt 1 ] 
then
    __msg_error "Could not create Genesis File"
    __msg_error "Exiting"
    exit 1
fi

TX_FILE_CREATED=$(ls /vagrant/config/channel.tx | wc -l)
if [ $TX_FILE_CREATED -lt 1 ] 
then
    __msg_error "Could not create TX File"
    __msg_error "Exiting"
    exit 1
fi

#Create orderers config folder
for (( i=1; i <= $GC_ORDERERS_COUNT; ++i ))
do
    mkdir -p /vagrant/orderer/orderer$i.grainchain.io/config/
    cp /vagrant/config/genesis.block /vagrant/orderer/orderer$i.grainchain.io/config/
    cp /vagrant/base-config-files/raft/orderer/orderer.yaml /vagrant/orderer/orderer$i.grainchain.io/config/
done

docker-compose -f /vagrant/base-config-files/raft/orderer/docker-compose-orderer.yaml down
docker-compose -f /vagrant/base-config-files/raft/orderer/docker-compose-orderer.yaml up -d 
