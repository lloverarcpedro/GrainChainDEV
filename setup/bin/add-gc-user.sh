
###--- ADD new user script ---### 

#Imports 
. ./utils/loging.sh

# set -o errexit
# set -o nounset
# set -o pipefail


# Function usage - help
function usage {

    __msg_help "Adds new users to certification Authority. "
    __msg_help "Usage:   ./add-gc-user.sh   <newUserId>       <newUserRole>   <newUserPassword>   <newUserOrg>   <orgAdminId>"
    __msg_help ""
    __msg_help "Example: ./add-gc-user.sh   pedro.llovera   client        pass               orderers    orderer-admin"
    __msg_help ""
    __msg_help "Values for newUserRole : user for end user"
    __msg_help "                   client for fabric component"
    __msg_help ""
    __msg_help "Values for newUserOrg : commodity or harvx or orderer"

    __msg_help "orgAdminId [optional]: need when adding no admin users"
}
# Function Enroll admin
function enrollUser {
    
    __msg_info "Enrolling: $USER_ID"
	export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/$USER_ORG/$USER_ID
	__msg_info "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"

	mkdir -p $FABRIC_CA_CLIENT_HOME

    fabric-ca-client enroll -u http://$USER_ID:$USER_PASS@localhost:7054

    #5 Setup new user MSP
    setupMSP
}

#Function Setup MSP
function setupMSP {

    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    __msg_info "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
     if [ $USER_ROLE == "admin" ];
    then
        cp /vagrant/ca/client/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
    else
        cp /vagrant/ca/client/$USER_ORG/$USER_ADMIN_ID/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
    fi

    exit 0
}

function registerUser {
    
    if [ $USER_ROLE == "admin" ];
    then
        #2. change fabric client home
        __msg_info "Registering $USER_ID as ORG-admin on $USER_ORG org"
        export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/admin
        ATTRIBUTES='"hf.Registrar.Roles=orderer,peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
         #3. Register the new user
        fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG --id.attrs $ATTRIBUTES
    else
        #2. change fabric client home
        __msg_info "Registering $USER_ID as ORG $USER_ROLE on $USER_ORG org"
        export FABRIC_CA_CLIENT_HOME=/vagrant/ca/client/$USER_ORG/$USER_ADMIN_ID
        fabric-ca-client register --id.type $USER_ROLE --id.name $USER_ID --id.secret $USER_PASS --id.affiliation $USER_ORG
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
    USER_ID=$1
    USER_ROLE=$2
    USER_PASS=$3
    USER_ORG=$4
    if [ $USER_ROLE == "admin" ];
    then
        USER_ADMIN_ID=""
    else
        if [ -z $5 ];
        then 
            usage
            echo   "MISSING PARAMETER"
            echo   "To ADD please provide org_admin_id"
            
            exit 1
        else
            USER_ADMIN_ID=$5
        fi
    fi
    registerUser
fi