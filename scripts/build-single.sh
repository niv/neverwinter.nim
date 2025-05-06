#!/bin/bash

test -e neverwinter.nimble || {
    echo "Please run this script from the root of the project."
    exit 1
}

valid_os=("windows" "linux" "macos")
valid_cpu=("x86_64" "aarch64")

cpu=$1; shift
os=$1; shift

set -e

if [ -z "$os" ]; then
    echo "Usage: $0 <cpu> <os> [nimble args...]"
    echo "Example: $0 x86_64 linux"
    exit 1
fi

if [[ ! " ${valid_os[*]} " =~ " ${os} " ]]; then
    echo "Error: Invalid OS. Must be one of: ${valid_os[*]}"
    exit 1
fi

if [[ ! " ${valid_cpu[*]} " =~ " ${cpu} " ]]; then
    echo "Error: Invalid CPU architecture. Must be one of: ${valid_cpu[*]}"
    exit 1
fi

script_dir=$(dirname "$(realpath "$0")")

for tool in cc c++ ar; do
    test -e "${script_dir}/zig-${tool}-${cpu}-${os}" || \
        ln -v -s "${script_dir}/zig-redirector.sh" "${script_dir}/zig-${tool}-${cpu}-${os}"
done

export CC="${script_dir}/zig-cc-${cpu}-${os}"
export CXX="${script_dir}/zig-c++-${cpu}-${os}"
export AR="${script_dir}/zig-ar-${cpu}-${os}"

nim_cpu_remap=$(echo "$cpu" | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')
nim_os_remap=$(echo "$os" | sed -e 's/macos/macosx/')

if [ "${os}" == "windows" ]; then
    lib_ext="dll"
elif [ "${os}" == "macos" ]; then
    lib_ext="dylib"
else
    lib_ext="so"
fi

mkdir -p dist

dist_file="dist/neverwinter-${cpu}-${os}.zip"

set -x

nimble tidy

nimble build --os:${nim_os_remap} --cpu:${nim_cpu_remap} \
    --backend:cpp \
    --gcc.exe:"$script_dir/zig-cc-${cpu}-${os}" \
    --gcc.cpp.exe:"$script_dir/zig-c++-${cpu}-${os}" \
    --gcc.linkerexe:"$script_dir/zig-cc-${cpu}-${os}" \
    --gcc.cpp.linkerexe:"$script_dir/zig-c++-${cpu}-${os}" \
    "$@"

${CXX} -fPIC -shared -O2 \
    neverwinter/nwscript/compilerapi.cpp \
    neverwinter/nwscript/native/*.{c,cpp} \
    -o bin/libnwnscriptcomp.${lib_ext}

cp -v neverwinter/nwscript/compilerapi.h bin/nwnscriptcomp.h

# Hotfix for zig adding random noise
rm -v bin/@* || true
rm -v bin/*.pdb || true
rm -v bin/*.lib || true

# Hotfix for nimble windows extension missing
if [ "${os}" == "windows" ]; then
    for file in bin/nwn_*; do
        if [[ "$file" != *.* ]]; then
            mv -v "$file" "$file.exe"
        fi
    done
fi

addn=""
if [ -d "dist/pkg-${cpu}-${os}" ]; then
    addn="dist/pkg-${cpu}-${os}"
fi

rm -v "${dist_file}" || true
zip -rj "${dist_file}" bin "${addn}" -x \*.DS_Store -x \*.gitkeep
