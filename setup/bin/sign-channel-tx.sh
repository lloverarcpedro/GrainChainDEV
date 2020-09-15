

# export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/msp
# export CORE_PEER_LOCALMSPID=/var/hyperledger/msp

# echo $CORE_PEER_MSPCONFIGPATH

peer channel signconfigtx --file /var/hyperledger/config/grainchainchannel-channel.tx

peer channel create -c grainchainchannel -f /var/hyperledger/config/grainchainchannel-channel.tx --outputBlock /var/hyperledger/config/grainchainchannel.block -o orderer.grainchain.io:7050