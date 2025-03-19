#!/bin/bash

rm -rf executor
sleep 1

EXECUTOR_URL="https://github.com/t3rn/executor-release/releases/download/v0.53.1/executor-linux-v0.53.1.tar.gz"
EXECUTOR_FILE="executor-linux-v0.53.1.tar.gz"

echo "Downloading the Executor binary from $EXECUTOR_URL..."
curl -L -o $EXECUTOR_FILE $EXECUTOR_URL

if [ $? -ne 0 ]; then
    echo "Failed to download the Executor binary. Please check your internet connection and try again."
    exit 1
fi

echo "Extracting the binary..."
tar -xzvf $EXECUTOR_FILE
rm -rf $EXECUTOR_FILE
cd executor/executor/bin

echo "Binary downloaded and extracted successfully."
echo

# Meminta input dari pengguna
echo -n "Your Private Key: "
read -s PRIVATE_KEY
echo

echo -n "Gas Price: "
read GAS_PRICE
echo

echo -n "API Key Alchemy: "
read APIKEY_ALCHEMY
echo

export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
export PRIVATE_KEY_LOCAL="$PRIVATE_KEY"
export EXECUTOR_MAX_L3_GAS_PRICE="$GAS_PRICE"
export ENABLED_NETWORKS="l2rn,arbitrum-sepolia,base-sepolia,blast-sepolia,optimism-sepolia,unichain-sepolia"
export RPC_ENDPOINTS='{
  "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
  "arbt": ["https://arbitrum-sepolia.drpc.org", "https://arb-sepolia.g.alchemy.com/v2/'$APIKEY_ALCHEMY'"],
  "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.g.alchemy.com/v2/'$APIKEY_ALCHEMY'"],
  "blst": ["https://sepolia.blast.io", "https://blast-sepolia.g.alchemy.com/v2/'$APIKEY_ALCHEMY'"],
  "opst": ["https://sepolia.optimism.io", "https://opt-sepolia.g.alchemy.com/v2/'$APIKEY_ALCHEMY'"],
  "unit": ["https://unichain-sepolia.drpc.org", "https://unichain-sepolia.g.alchemy.com/v2/'$APIKEY_ALCHEMY'"]
}'

sleep 2
echo "Starting the Executor..."
./executor
