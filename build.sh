#!/bin/bash

set -e

pushd src
for v in *.nim; do
  nim -o:"../bin/$(basename $v .nim)" -d:release c $v
done
popd
