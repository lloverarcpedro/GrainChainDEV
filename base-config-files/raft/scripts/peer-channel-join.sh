export CORE_PEER_ADDRESS=$1 #peer1-org2:7051
export CORE_PEER_MSPCONFIGPATH="/tmp/hyperledger/org/users/admin/msp"  #admin msp dir, mounted on tools container /tmp/hyperledger/org/admin/msp
#JOIN CHANNEL
peer channel join -b /tmp/hyperledger/txconfig/mychannel.block
