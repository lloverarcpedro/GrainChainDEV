
###--- ADD new ca user script ---### 
## Last update Sep 18 2020 ##
# Author: Pedro Llovera #

#Imports 
. /vagrant/bin/utils/loging.sh

# set -o errexit
# set -o nounset
# set -o pipefail


# Function usage - help
function usage {

    __msg_help "Adds new users to certification Authority. "
    __msg_help "Usage:   ./add-gc-user.sh   <newUserId>      <newUserRole>   <newUserPassword>   <newUserOrg>   <tlsEnabled>"
    __msg_help ""
    __msg_help "Example: ./add-gc-user.sh   pedro.llovera    client          pass                orderer       tls"
    __msg_help ""
    __msg_help "Values for newUserRole : user for end user"
    __msg_help "                   client for fabric component"
    __msg_help ""
    __msg_help "Values for newUserOrg : commodity or harvx or orderer"
    __msg_help ""
    __msg_help "tlsEnable [optional]: need when tls is enabled"
}
# Function Enroll admin
function enrollUser {
    cd $HOME_DIR

    __msg_header "Enrolling: $USER_ID"

    if [ $USER_ORG == "orderer" ]
    then 
        export FABRIC_CA_CLIENT_HOME=/vagrant/config/crypto-config/ordererOrganizations/orderer.io/$USER_PARENT_DIR/$USER_ID
    else
        export FABRIC_CA_CLIENT_HOME=/vagrant/config/crypto-config/peerOrganizations/$USER_ORG.io/$USER_PARENT_DIR/$USER_ID
    fi
	__msg_info "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
	mkdir -p $FABRIC_CA_CLIENT_HOME


    cd $FABRIC_CA_CLIENT_HOME

    if [ $TLS_ENABLED == "true" ]
    then
        fabric-ca-client enroll -u https://$USER_ID:$USER_PASS@localhost:7054 --tls.certfiles /vagrant/ca/server/config/ca-cert.pem
    else
        fabric-ca-client enroll -u http://$USER_ID:$USER_PASS@localhost:7054
    fi

    if [ $USER_ROLE == "admin" ]
    then
    #copy ca admin cert to org admin folder
        mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
        cp $CA_ADMIN_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts/
        LIST=$(ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/)
        __msg_debug "Copied admin certs to $FABRIC_CA_CLIENT_HOME/msp/admincerts/"
        __msg_debug "$LIST"
        #DELETE CA ADMIN FOLDER 
        rm -rf $CA_ADMIN_HOME
    fi
    #5 Setup new user MSP
    setupMSP
}

#Function Setup MSP
function setupMSP {
    __msg_header "Setup MSP: $USER_ID"
    cd $FABRIC_CA_CLIENT_HOME/../..
    export ORG_HOME=$PWD
    __msg_info " ORG HOME ====> $ORG_HOME"
    __msg_info "CERTS CP ====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"

     if [ $USER_ROLE == "admin" ];
    then
        mkdir -p $ORG_HOME/msp/admincerts
        mkdir -p $ORG_HOME/msp/cacerts
        mkdir -p $ORG_HOME/msp/tlscacerts
        mkdir -p $ORG_HOME/ca
        mkdir -p $ORG_HOME/tlsca
        cp $ORG_HOME/users/Admin@$USER_ORG.io/msp/signcerts/*  $ORG_HOME/msp/admincerts/
        cp /vagrant/ca/server/config/ca-cert.pem $ORG_HOME/msp/cacerts/
        cp /vagrant/ca/server/config/ca-cert.pem $ORG_HOME/ca/

        if [ $TLS_ENABLED == "true" ]
        then
            __msg_info "CA TLS CP ====> $FABRIC_CA_CLIENT_HOME/msp/tlscacerts"
            cp /vagrant/ca/server/config/tls-cert.pem $ORG_HOME/msp/tlscacerts/
            mkdir -p $FABRIC_CA_CLIENT_HOME/msp/tlscacerts
            cp /vagrant/ca/server/config/tls-cert.pem $FABRIC_CA_CLIENT_HOME/msp/tlscacerts/
        fi

    else
        mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
        cp $ORG_HOME/users/Admin@$USER_ORG.io/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts/
        __msg_debug "Admincerts copied ====> $FABRIC_CA_CLIENT_HOME/msp/admincerts/"
        LIST=$(ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/)
        __msg_debug "$LIST"
        if [ $TLS_ENABLED == "true" ]
        then
            __msg_info "CA TLS CP ====> $FABRIC_CA_CLIENT_HOME/msp/tlscacerts"
            mkdir -p $FABRIC_CA_CLIENT_HOME/msp/tlscacerts
            cp /vagrant/ca/server/config/tls-cert.pem $FABRIC_CA_CLIENT_HOME/msp/tlscacerts/
        fi
    fi

    exit 0
}

function registerUser {
__msg_header "Registering: $USER_ID"

if [ $USER_ROLE == "admin" ];
    then 
        export USER_ID=Admin@$USER_ORG.io
        export USER_PARENT_DIR="users"
    elif [ $USER_ROLE == "peer" ]
    then
        export USER_PARENT_DIR="peers"
        export USER_ID=$USER_ID@$USER_ORG.io
    elif [ $USER_ROLE == "orderer" ]
    then
        export USER_PARENT_DIR="orderers"
        export USER_ID=$USER_ID@$USER_ORG.io
    else
        export USER_PARENT_DIR="users"
        export USER_ID=$USER_ID@$USER_ORG.io
    fi
    __msg_info "Enrolling: $USER_ID"

    if [ $USER_ORG == "orderer" ]
    then 
        export FABRIC_CA_CLIENT_HOME=/vagrant/config/crypto-config/ordererOrganizations/orderer.io/$USER_PARENT_DIR/$USER_ID
    else
        export FABRIC_CA_CLIENT_HOME=/vagrant/config/crypto-config/peerOrganizations/$USER_ORG.io/$USER_PARENT_DIR/$USER_ID
    fi
    mkdir -p $FABRIC_CA_CLIENT_HOME
    cd $FABRIC_CA_CLIENT_HOME/../..
    export ORG_HOME=$PWD

    
    if [ $USER_ROLE == "admin" ]
    then
        #2. change fabric client home
        __msg_header "Registering $USER_ID as ORG-admin on $USER_ORG org"
        cd $ORG_HOME/../..
        mkdir -p caAdmin
        cd caAdmin
        export FABRIC_CA_CLIENT_HOME=$PWD
        CA_ADMIN_HOME=$PWD
        #enroll ca admin to create org admins
        if [ $TLS_ENABLED == "true" ] 
        then
            fabric-ca-client enroll -u https://admin:gc2020bc@localhost:7054 --tls.certfiles /vagrant/ca/server/config/ca-cert.pem
        else
            fabric-ca-client enroll -u http://admin:gc2020bc@localhost:7054
        fi
        export FABRIC_CA_ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME
        __msg_info "CA ADMIN HOME ====> $FABRIC_CA_CLIENT_HOME"
        ATTRIBUTES='"hf.Registrar.Roles=orderer,peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
         
         #3. Register the new user
        if [ $TLS_ENABLED == "true" ]  
        then
            fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG --id.attrs $ATTRIBUTES --tls.certfiles /vagrant/ca/server/config/ca-cert.pem
            __msg_info $PWD
        else
            fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG --id.attrs $ATTRIBUTES
        fi

    else
        #2. change fabric client home
        __msg_info "Registering $USER_ID as ORG $USER_ROLE on $USER_ORG org"
        cd $FABRIC_CA_CLIENT_HOME/../../users/Admin@$USER_ORG.io
        export FABRIC_CA_CLIENT_HOME=$PWD
         __msg_info "ORG ADMIN HOME ====> $FABRIC_CA_CLIENT_HOME"
         if [ $TLS_ENABLED == "true" ] 
        then
            fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG --tls.certfiles /vagrant/ca/server/config/ca-cert.pem
        else
            fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG
        fi
        
    fi

    #4 Enrol registered user
    enrollUser
}


#1 parameters validation
if [ $1 = "-h" ];
then 
    usage
elif [ $1 = "-help" ];
then
    usage

elif [ -z $1 ];
then
    usage
    __msg_error   "MISSING PARAMETER"
    __msg_error   "Please provide newUserID"
    exit 1
elif [ -z $2 ];
then
    usage
    __msg_error   "MISSING PARAMETER"
    __msg_error   "Please provide newUserRole client or user"
    exit 1
elif [ -z $3 ];
then
    usage
    __msg_error   "MISSING PARAMETER"
    __msg_error   "Please provide newUserPassword"
    exit 1 
elif [ -z $4 ];
then
    usage
    __msg_error   "MISSING PARAMETER"
    __msg_error   "Please provide newUserOrg"
    exit 1
else 
    if [ -z $5 ]
    then
        TLS_ENABLED="false"
    else
        if [ $5 == "true" ]
        then
            TLS_ENABLED="true"
        else
            TLS_ENABLED="false"
        fi
    fi
    USER_ID=$1
    USER_ROLE=$2
    USER_PASS=$3
    USER_ORG=$4
    HOME_DIR=$PWD
    if [ $USER_ROLE == "admin" ];
    then
        USER_ADMIN_ID=""
    fi
    registerUser
fi