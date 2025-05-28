#!/bin/sh
# Copyright 2025 Brick Towers

set -e  # exit on error
set -x  # print each command before executing

# Default CIRCUIT_PARAM_RANGE if not provided
CIRCUIT_PARAM_RANGE=${CIRCUIT_PARAM_RANGE:-"10 11 12 13 14 15 16 17"}
ZK_PARAMS_DIR=${ZK_PARAMS_DIR:-".cache/midnight/zk-params"}

# Create target directory
mkdir -p "$ZK_PARAMS_DIR/zswap/4"

echo "📥 Downloading BLS Filecoin params..."
for i in $CIRCUIT_PARAM_RANGE; do
  echo "  ↳ bls_filecoin_2p$i"
  curl -sSLo "$ZK_PARAMS_DIR/bls_filecoin_2p$i" \
    "https://midnight-s3-fileshare-dev-eu-west-1.s3.eu-west-1.amazonaws.com/bls_filecoin_2p$i"
done

echo "📥 Downloading zswap/4 circuits..."
cd "$ZK_PARAMS_DIR/zswap/4" || exit 1
for file in \
  output.bzkir output.prover output.verifier \
  sign.bzkir sign.prover sign.verifier \
  spend.bzkir spend.prover spend.verifier; do
  echo "  ↳ $file"
  curl -sSLO "https://midnight-s3-fileshare-dev-eu-west-1.s3.eu-west-1.amazonaws.com/zswap/4/$file"
done
