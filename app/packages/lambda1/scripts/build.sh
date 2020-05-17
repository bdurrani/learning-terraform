#!/usr/bin/env bash

set -euo pipefail

OUTPUT_PATH=$1
echo "Output path: $OUTPUT_PATH"

function check_deps() {
  test -f $(which zip) || error_exit "zip command not detected in path, please install it"
}

zip -X -r ${OUTPUT_PATH}/deploy.zip .  -x "./test/*" -x "./scripts/*"