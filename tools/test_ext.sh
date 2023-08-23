#!/bin/bash
set -e

SCRIPT_DIR=$(dirname ${BASH_SOURCE})
ext_to_test="$1"
shift 1;
"$SCRIPT_DIR/../kit/kit" --enable omni.kit.test --/exts/omni.kit.test/testExts/0="$ext_to_test" --/app/enableStdoutOutput=0 --portable-root "$SCRIPT_DIR/.." "$@"
