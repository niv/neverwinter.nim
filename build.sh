#!/bin/sh

for v in src/*.nim; do
  nim -p:"extlib/neverwinter.nim/src" -o:"bin/$(basename $v .nim)" -d:release c $v
done
