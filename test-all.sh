#!/bin/bash
# Runs the test to validate the environment
# Usage:  ./test-all.sh [tls]
# If the $1 = "tls" then Orderer and Peers are launched with TLS enabled
# ENV must be up before this script is used

SLEEP_TIME=3s

echo "1....... As grainchain install the chaincode ....."
. ./bins/set-context.sh   grainchain   $1

./bins/cc-test.sh install

echo "2....... As grainchain instantiate the chaincode ....."
./bins/cc-test.sh instantiate

sleep $SLEEP_TIME

echo "3....... Query the chaincode ......"
./bins/cc-test.sh   query

echo "7....... As grainchain Query the chaincode ......"
. ./bins/set-context.sh   grainchain   $1
./bins/cc-test.sh   query

echo "All tests completed"