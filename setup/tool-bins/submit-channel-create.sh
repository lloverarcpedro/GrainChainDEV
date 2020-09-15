#!/bin/bash
peer channel create -c grainchainchannel -f /var/hyperledger/config/grainchainchannel-channel.tx --outputBlock /var/hyperledger/config/grainchainchannel-0.block -o $ORDERER_ADDRESS
