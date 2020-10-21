#Imports 
. /vagrant/bin/utils/loging.sh

__msg_info "Starting GC HLF RAFT Deploy"
#INIT CAs
/vagrant/base-config-files/raft/scripts/ca-init.sh

#SETUP ORDERERS
/vagrant/base-config-files/raft/scripts/orderer-setup.sh

#Setup Peers
/vagrant/base-config-files/raft/scripts/peer-setup.sh