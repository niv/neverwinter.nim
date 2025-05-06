#!/bin/bash

set -e

test -e neverwinter.nimble || {
    echo "Please run this script from the root of the project."
    exit 1
}

script_dir=$(dirname "$(realpath "$0")")

for os in linux macos windows; do
    for cpu in x86_64 aarch64; do
        ./scripts/build-single.sh "$cpu" "$os" "$@"
    done
done
