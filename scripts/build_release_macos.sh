#!/bin/bash
set -ex

nimble clean
rm -rv bin-x86_64 || true
rm -rv bin-arm64 || true

nimble build -d:release -d:macos_amd64 "$@"
mv bin bin-x86_64

nimble build -d:release -d:macos_arm64 "$@"
mv bin bin-arm64

mkdir bin
for i in bin-x86_64/*; do
    base=$(basename "$i")
    lipo -create -output bin/$base bin-x86_64/"$base" bin-arm64/"$base"
done

rm -rv bin-x86_64 bin-arm64
