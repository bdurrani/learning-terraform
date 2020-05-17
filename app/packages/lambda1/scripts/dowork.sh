#!/usr/bin/env bash

set -euo pipefail
# ls ../..
source ../../scripts/utils.sh
npm ci --production > /dev/null 2>&1
OUTPUT_PATH=$1
# echo "args ${OUTPUT_PATH} $(pwd)"
# hello ${OUTPUT_PATH}
DEPLOYMENT_PACKAGE=$(make_deterministic_zip ${OUTPUT_PATH})
echo "deployment package: ${DEPLOYMENT_PACKAGE}"
echo "md5 $(md5sum "${DEPLOYMENT_PACKAGE}" | head -c 32)"
SHASUM=$(sha256sum "${DEPLOYMENT_PACKAGE}" | head -c 64 | xxd -r -p | base64)
echo "shasum ${SHASUM}"
