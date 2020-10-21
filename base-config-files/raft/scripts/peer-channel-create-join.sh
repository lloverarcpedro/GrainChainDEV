export CORE_PEER_ADDRESS=$1 #peer1-org2:7051
export GC_CHANNEL_NAME=$2 #mychannel
export CORE_PEER_MSPCONFIGPATH="/tmp/hyperledger/org/users/admin/msp"  #admin msp dir, mounted on tools container /tmp/hyperledger/org/admin/msp

peer channel create -c $GC_CHANNEL_NAME -f /tmp/hyperledger/txconfig/channel.tx -o orderer1.grainchain.io:7050 --outputBlock /tmp/hyperledger/txconfig/mychannel.block --tls --cafile /tmp/hyperledger/org/msp/tlscacerts/ca-cert.pem

#JOIN CHANNEL
peer channel join -b /tmp/hyperledger/txconfig/mychannel.block