#!/bin/bash
# Sets the environment vrs based on the passed parameter
# Usage:  . set-context.sh  acme         |        .  set-context.sh  budget

# Expected to be either acme *or*  budget
export ORG_CONTEXT=$1
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_CONTEXT:0:1})${ORG_CONTEXT:1}"
export ORG_NAME=$MSP_ID

# Logging specifications
export FABRIC_LOGGING_SPEC=INFO

# Location of the core.yaml
export FABRIC_CFG_PATH=/var/hyperledger/config/

# Address of the peer
export CORE_PEER_ADDRESS=peer1.grainchain.io:7051



# Local MSP for the admin - Commands need to be executed as org admin
export CORE_PEER_MSPCONFIGPATH=/var/hyperledger/config/vagrant/ca/client/config/crypto-config/peerOrganizations/harvx.io/users/Admin@harvx.io/msp

# Address of the orderer
export ORDERER_ADDRESS=orderer1.grainchain.io:7050

#### Introduced in Fabric 2.x update
#### Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","pedro","100","jose","200"]}'
export CC_NAME="gocc1"
export CC_PATH="chaincode_example02"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="grainchainchannel"
export CC_LANGUAGE="golang"

# Version 2.x
export INTERNAL_DEV_VERSION="1.0"
export CC2_PACKAGE_FOLDER="$HOME/packages"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"

# Create the package with this name
export PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"
# Extracts the package ID for the installed chaincode
export LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"

mkdir -p $CC2_PACKAGE_FOLDER
