#!/bin/bash

set -e

SCRIPT_NAME=$(basename "$0")

if [[ "$SCRIPT_NAME" =~ ^zig-(cc|c\+\+)\-(.+)-(.+)$ ]]; then
    REDIR=${BASH_REMATCH[1]}
    ARCH=${BASH_REMATCH[2]}
    PLATFORM=${BASH_REMATCH[3]}
    zig "$REDIR" -target "$ARCH-$PLATFORM" "$@"
    exit $?
fi

echo "Not symlinked" >&2
exit 1
