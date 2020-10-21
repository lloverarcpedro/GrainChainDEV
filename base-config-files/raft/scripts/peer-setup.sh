#Imports 
. /vagrant/bin/utils/loging.sh
export GC_HARVX_PEERS_COUNT=5
export GC_COMMODITY_PEERS_COUNT=5
#Create harvx peers config folder 
for (( i=1; i <= $GC_HARVX_PEERS_COUNT; ++i ))
do
    mkdir -p /vagrant/peer/peer$i-harvx.grainchain.io/config/
    cp /vagrant/config/channel.tx /vagrant/peer/peer$i-harvx.grainchain.io/config/
    cp /vagrant/base-config-files/raft/peer/core.yaml /vagrant/peer/peer$i-harvx.grainchain.io/config/
done

#Create commodity peers config folder 
for (( i=1; i <= $GC_COMMODITY_PEERS_COUNT; ++i ))
do
    mkdir -p /vagrant/peer/peer$i-commodity.grainchain.io/config/
    cp /vagrant/config/channel.tx /vagrant/peer/peer$i-commodity.grainchain.io/config/
    cp /vagrant/base-config-files/raft/peer/core.yaml /vagrant/peer/peer$i-commodity.grainchain.io/config/
done
docker-compose -f /vagrant/base-config-files/raft/peer/docker-compose-peer.yaml down

docker-compose -f /vagrant/base-config-files/raft/peer/docker-compose-peer.yaml up -d


docker-compose -f /vagrant/base-config-files/raft/tools-bin/tools-bin.yaml down
sleep 10
docker-compose -f /vagrant/base-config-files/raft/tools-bin/tools-bin.yaml up -d 
sleep 10



#Create channel and join 
docker exec -it cli-harvx.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-channel-create-join.sh peer1-harvx.grainchain.io:7051 grainchainchannel"
#Join Peer 2 to channel 
docker exec -it cli-harvx.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-channel-join.sh peer2-harvx.grainchain.io:7051"

#Join peer 1 commodity 
docker exec -it cli-commodity.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-channel-join.sh peer1-commodity.grainchain.io:7051"
#Join peer 2 commodity to channel
docker exec -it cli-commodity.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-channel-join.sh peer2-commodity.grainchain.io:7051"

#Install approve and instantiate CC
docker exec -it cli-harvx.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-install-approve-cc.sh peer1-harvx.grainchain.io:7051 grainchainchannel 1"

#Install and query on peer 2
docker exec -it cli-harvx.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-install-cc.sh peer2-harvx.grainchain.io:7051 grainchainchannel"

#Install, approve and query for Commodity org
docker exec -it cli-commodity.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-install-approve-cc.sh peer1-commodity.grainchain.io:7051 grainchainchannel 2"

#Install and query on peer2 commodity
docker exec -it cli-commodity.grainchain.io sh -c "/tmp/hyperledger/scripts/peer-install-cc.sh peer2-commodity.grainchain.io:7051 grainchainchannel"