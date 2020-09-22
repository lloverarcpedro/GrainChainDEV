###--- ADD org MSP ---### 

#Imports 
. ./utils/loging.sh

# set -o errexit
# set -o nounset
# set -o pipefail

function usage {
    __msg_help    "Creates the admincerts folder and copies the admin's cert to admincerts folder"
    __msg_help    "Usage:    add-org-msp.sh <ORG-Name> <ORG-Admin_ID>"
    
}

#1. Validate Inputs
if [ -z $1 ]
then
    __msg_error "Please provide ORG-Name!!!"
    usage
    exit 0
elif [ -z $2 ]
then
    __msg_error "Please provide ORG-Admin_ID!!!"
    usage
    exit 0
else 
    ORG_NAME=$1
    ORG_ADMIN_ID=$2
fi

#2. Set the destination as ORG folder
if [ ORG_NAME == "orderer.grainchain.io"]
then
    export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/config/crypto-config/ordererOrganizations/$ORG_NAME/$ORG_ADMIN_ID
else
    export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/config/crypto-config/peerOrganizations/$ORG_NAME/$ORG_ADMIN_ID
fi
__msg_info "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

#3. Path to the CA certificate
ROOT_CA_CERTIFICATE=/vagrant/ca/server/config/ca-cert.pem

#4. Parent folder for the MSP folder
DESTINATION_CLIENT_HOME="$FABRIC_CA_CLIENT_HOME/.."

#5. Create the MSP subfolders
mkdir -p $DESTINATION_CLIENT_HOME/msp/admincerts 
mkdir -p $DESTINATION_CLIENT_HOME/msp/cacerts  
mkdir -p $DESTINATION_CLIENT_HOME/msp/keystore
mkdir -p $DESTINATION_CLIENT_HOME/msp/signcerts

#6. Copy the Root CA Cert
cp $ROOT_CA_CERTIFICATE $DESTINATION_CLIENT_HOME/msp/cacerts

#7. Copy the admin certs - ORG admin is the admin for the specified Org
cp $FABRIC_CA_CLIENT_HOME/msp/signcerts/* $DESTINATION_CLIENT_HOME/msp/admincerts         

__msg_info "Created MSP Under: $DESTINATION_CLIENT_HOME"

exit 0