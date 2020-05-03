#!/usr/bin/env bash

set -euo pipefail
# https://www.terraform.io/docs/providers/external/data_source.html
REPO_DIR="/home/bdurrani/terraform/app"
# DEPLOY_TARGET_DIR="/home/bdurrani/terraform/stage/services/data_test"
DEPLOY_TARGET_DIR=""
PACKAGE_NAME=app

function check_deps() {
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

function parse_input(){
  eval "$(jq -r '@sh "PACKAGE_NAME=\(.package_name) DEPLOY_TARGET_DIR=\(.deploy_dir) REPO_DIR=\(.repo_dir)"')"
  if [[ -z "${PACKAGE_NAME}" ]]; then export PACKAGE_NAME=none; fi
  if [[ -z "${DEPLOY_TARGET_DIR}" ]]; then export DEPLOY_TARGET_DIR=none; fi
  if [[ -z "${REPO_DIR}" ]]; then export REPO_DIR=none; fi
}

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function generate_output(){
  jq -n \
      --arg target_dir "${DEPLOY_TARGET_DIR}" \
      --arg shasum "${SHASUM}" \
      '{"target_dir":$target_dir, "shasum":$shasum}' 
}
# https://gist.github.com/irvingpop/968464132ded25a206ced835d50afa6b

check_deps
parse_input

# Build the deployment package using lerna
cd ${REPO_DIR}

# pipe all output to null. Terraform doesn't like non-json output
lerna run --loglevel=silent --scope ${PACKAGE_NAME} build:deployment -- "${DEPLOY_TARGET_DIR}" > /dev/null 2>&1
# echo "{\"result\":\"${PACKAGE_NAME}\"}" 

SHASUM=$(sha256sum "${DEPLOY_TARGET_DIR}/deploy.zip" | head -c 64 | xxd -r -p | base64)
generate_output

# jq -n \
#     --arg target_dir "${DEPLOY_TARGET_DIR}" \
#     --arg shasum "${SHASUM}" \
#     '{"target_dir":$target_dir, "shasum":$shasum}'