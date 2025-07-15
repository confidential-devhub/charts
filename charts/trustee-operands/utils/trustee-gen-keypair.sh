#!/bin/bash
set -euo pipefail

OUT_DIR="files"
mkdir -p "${OUT_DIR}"

# Generate keys
openssl genpkey -algorithm ed25519 -out "${OUT_DIR}/privateKey"
openssl pkey -in "${OUT_DIR}/privateKey" -pubout -out "${OUT_DIR}/publicKey"

base64 -w 0 ${OUT_DIR}/publicKey > ${OUT_DIR}/publicKey.b64

echo "✅ Keys written to ${OUT_DIR}:"
echo "   - ${OUT_DIR}/privateKey"
echo "   - ${OUT_DIR}/publicKey"
echo "   - ${OUT_DIR}/publicKey.b64"
