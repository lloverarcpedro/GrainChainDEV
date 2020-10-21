#CREATE GENESIS
cd /vagrant/tmp/yamls/configtx/
configtxgen -profile OrgsOrdererGenesis -outputBlock /vagrant/tmp/hyperledger/org0/orderer1/genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx /vagrant/tmp/hyperledger/org0/orderer1/channel.tx -channelID mychannel

cp /vagrant/tmp/hyperledger/org0/orderer1/genesis.block /vagrant/tmp/hyperledger/org0/orderer2/genesis.block
cp /vagrant/tmp/hyperledger/org0/orderer1/genesis.block /vagrant/tmp/hyperledger/org0/orderer3/genesis.block
cp /vagrant/tmp/hyperledger/org0/orderer1/genesis.block /vagrant/tmp/hyperledger/org0/orderer4/genesis.block
cp /vagrant/tmp/hyperledger/org0/orderer1/genesis.block /vagrant/tmp/hyperledger/org0/orderer5/genesis.block
cp /vagrant/tmp/hyperledger/org0/orderer1/channel.tx /vagrant/tmp/hyperledger/org0/orderer2/channel.tx
cp /vagrant/tmp/hyperledger/org0/orderer1/channel.tx /vagrant/tmp/hyperledger/org0/orderer3/channel.tx
cp /vagrant/tmp/hyperledger/org0/orderer1/channel.tx /vagrant/tmp/hyperledger/org0/orderer4/channel.tx
cp /vagrant/tmp/hyperledger/org0/orderer1/channel.tx /vagrant/tmp/hyperledger/org0/orderer5/channel.tx
cd /vagrant



#PEERS UP

docker-compose -f tmp/yamls/ca/org1-peer1.yaml up -d
sleep 5
docker logs peer1-org1

docker-compose -f tmp/yamls/ca/org1-peer2.yaml up -d
sleep 5
docker logs peer2-org1

docker-compose -f tmp/yamls/ca/org2-peer1.yaml up -d
sleep 5
docker logs peer1-org2

docker-compose -f tmp/yamls/ca/org2-peer2.yaml up -d
sleep 5
docker logs peer2-org2

#ORDERER UP
docker-compose -f tmp/yamls/ca/org0-orderer1.yaml up -d
sleep 5
docker logs orderer1-org0

#CLIS UP
docker-compose -f tmp/yamls/ca/tools-bin.yaml up -d
sleep 5

#CREATE CHANNEL
cp /vagrant/tmp/hyperledger/org0/orderer1/channel.tx /vagrant/tmp/hyperledger/org1/peer1/assets/
#CLI1
docker exec -it cli-org1 sh

export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp
peer channel create -c mychannel -f /tmp/hyperledger/org1/peer1/assets/channel.tx -o orderer1-org0:7050 --outputBlock /tmp/hyperledger/org1/peer1/assets/mychannel.block --tls --cafile /tmp/hyperledger/org1/peer1/tls-msp/tlscacerts/tls-0-0-0-0-7052.pem


#JOIN CHANNEL ORG1

export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/admin/msp
export CORE_PEER_ADDRESS=peer1-org1:7051
peer channel join -b /tmp/hyperledger/org1/peer1/assets/mychannel.block

export CORE_PEER_ADDRESS=peer2-org1:7051
peer channel join -b /tmp/hyperledger/org1/peer1/assets/mychannel.block

exit

#JOIN CHANNEL ORG2
cp /vagrant/tmp/hyperledger/org1/peer1/assets/mychannel.block /vagrant/tmp/hyperledger/org2/peer1/assets/

docker exec -it cli-org2 sh

export CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org2/admin/msp
export CORE_PEER_ADDRESS=peer1-org2:7051
peer channel join -b /tmp/hyperledger/org2/peer1/assets/mychannel.block
export CORE_PEER_ADDRESS=peer2-org2:7051
peer channel join -b /tmp/hyperledger/org2/peer1/assets/mychannel.block

exit