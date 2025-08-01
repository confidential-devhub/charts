#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <provider>"
    return
fi

PROVIDER=$1
# shift

PROVIDER_SCRIPT="./set-values/${PROVIDER}.sh"
if [[ ! -f ${PROVIDER_SCRIPT} ]]; then
    echo "Unsupported provider: ${PROVIDER}"
    return
fi

source "${PROVIDER_SCRIPT}"
