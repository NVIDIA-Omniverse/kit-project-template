#!/bin/bash
set -e
SCRIPT_DIR=$(dirname ${BASH_SOURCE})
exec "$SCRIPT_DIR/../../kit/kit" "$SCRIPT_DIR/my_name.my_app.kit" "$@"
