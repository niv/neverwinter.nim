#!/bin/bash

set -e

pushd src
for v in *.nim; do
  echo "Building: $v"
  nim -o:"../bin/$(basename $v .nim)" -d:release c $v
done
popd
