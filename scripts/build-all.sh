#!/bin/bash

set -e

TARGETS=(
  "x86_64-linux-musl"
  "x86_64-macos"
  "x86_64-windows"
  "aarch64-linux-musl"
  "aarch64-macos"
  "aarch64-windows"
)

test -e neverwinter.nimble || {
    echo "Please run this script from the root of the project."
    exit 1
}

script_dir=$(dirname "$(realpath "$0")")

set -x

for target in "${TARGETS[@]}"; do
    ./scripts/build-single.sh "${target}" "$@"
done
