#Logging functions
function __msg_error() {
    echo -e "\e[31m[ERROR]\e[0m : \e[41m\e[1m****** $* ******\e[0m"
}

function __msg_debug() {
    echo -e "\e[42m[DEBUG] \e[0m: $*"
}

function __msg_info() {
    echo -e "[INFO] : \e[1m$*\e[0m"
}

function __msg_help() {
    echo -e "\e[92m[HELP]\e[0m : \e[1m$*\e[0m"
}

function __msg_header() {
    echo -e "\e[35m[INFO]\e[0m : \e[1m$*\e[0m"
}