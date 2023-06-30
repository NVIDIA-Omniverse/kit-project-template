#!/bin/bash
set -e
SCRIPT_DIR=$(dirname ${BASH_SOURCE})
source "$SCRIPT_DIR/../repo.sh" precache_exts -u $@ || exit $?
