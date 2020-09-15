

# export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/msp
# export CORE_PEER_LOCALMSPID=/var/hyperledger/msp

# echo $CORE_PEER_MSPCONFIGPATH

# peer channel signconfigtx --file /var/hyperledger/config/grainchainchannel-channel.tx --cafile /var/hyperledger/config/caclient/orderer/orderer-admin/msp/cacerts --certfile /var/hyperledger/config/caclient/orderer/orderer-admin/msp/signcerts
# peer channel signconfigtx --file /var/hyperledger/config/grainchainchannel-channel.tx

peer channel create -c grainchainchannel -f /vagrant/peer/config/grainchainchannel-channel.tx --outputBlock /vagrant/peer/config/grainchainchannel-0.block -o orderer.grainchain.io:7050
peer channel create -c grainchainchannel -f ./grainchainchannel-channel.tx --outputBlock ./grainchainchannel-0.block -o orderer.grainchain.io:7050