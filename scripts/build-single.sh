#!/bin/bash

test -e neverwinter.nimble || {
    echo "Please run this script from the root of the project."
    exit 1
}

target=$1; shift

set -e

if [ -z "$target" ]; then
    echo "Usage: $0 <target> [nimble args...]"
    echo "Example: $0 x86_64-linux-gnu -d:release"
    exit 1
fi

script_dir=$(dirname "$(realpath "$0")")

for tool in cc c++ ar; do
    test -e "${script_dir}/zig-${tool}-${target}" || \
        ln -v -s "${script_dir}/zig-redirector.sh" "${script_dir}/zig-${tool}-${target}"
done

export CC="${script_dir}/zig-cc-${target}"
export CXX="${script_dir}/zig-c++-${target}"
export AR="${script_dir}/zig-ar-${target}"

cpu=$(echo $target | cut -d'-' -f1)
os=$(echo $target | cut -d'-' -f2)

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

dist_file="dist/neverwinter-${target}.zip"

set -x

nimble tidy

zigcc="${script_dir}/zig-cc-${target}"
zigcxx="${script_dir}/zig-c++-${target}"

nimflags=(--os:${nim_os_remap} --cpu:${nim_cpu_remap} --backend:cpp)

if [ "${os}" == "macos" ]; then
    # Apple clang is a cross compiler and the SDK it needs only exists on macOS.
    # zig is no good here: its bundled macOS stubs have no Apple frameworks.
    if [ "${cpu}" == "aarch64" ]; then
        macos_triple="arm64-apple-macos11.0"
    else
        macos_triple="x86_64-apple-macos10.12"
    fi
    # joined form: nimble re-splits forwarded arguments on whitespace, so the
    # "-target <triple>" spelling would arrive as a stray positional argument
    nimflags+=(
        --passC:"--target=${macos_triple}"
        --passL:"--target=${macos_triple}"
    )
else
    # Nim keys the compiler overrides on the selected C compiler family, which
    # is gcc for linux and windows targets.
    nimflags+=(
        --gcc.exe:"$zigcc"
        --gcc.cpp.exe:"$zigcxx"
        --gcc.linkerexe:"$zigcc"
        --gcc.cpp.linkerexe:"$zigcxx"
    )
fi

nimble build "${nimflags[@]}" "$@"

expected=$(sed -n '/^bin = @\[/,/^]/p' neverwinter.nimble | grep -o '"[^"]*"' | tr -d '"')
if [ -z "${expected}" ]; then
    echo "could not parse the bin list out of neverwinter.nimble" >&2
    exit 1
fi

# Resolve the nimble bin list against what is actually in bin/, failing on gaps
collect_bins() {
    local exe
    payload=()
    while IFS= read -r exe; do
        if [ -e "bin/${exe}" ]; then
            payload+=("bin/${exe}")
        elif [ -e "bin/${exe}.exe" ]; then
            payload+=("bin/${exe}.exe")
        else
            echo "incomplete build: bin/${exe} is missing" >&2
            return 1
        fi
    done <<< "${expected}"
}

collect_bins

if [ "${os}" == "macos" ]; then
    dylib_cxx=(c++ "--target=${macos_triple}")
    dylib_flags=(-Wno-deprecated-declarations)
else
    dylib_cxx=("${CXX}")
    dylib_flags=()
fi

"${dylib_cxx[@]}" -fPIC -shared -O2 "${dylib_flags[@]}" \
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

# The artifact is exactly what the build scaffold produced: the nimble bin
# list plus the compiler library and its header. Anything else in bin/ is
# ignored, so stray files can neither fail the checks below nor ship.
collect_bins
payload+=("bin/libnwnscriptcomp.${lib_ext}" "bin/nwnscriptcomp.h")

# Guard against the toolchain silently falling back to the host compiler
if [ "${os}" == "macos" ]; then
    want=$([ "${cpu}" == "aarch64" ] && echo arm64 || echo x86_64)
    bad=""
    for f in "${payload[@]}"; do
        case "${f}" in
            *.h) continue ;;
        esac
        desc=$(file -b "${f}")
        case "${desc}" in
            *Mach-O*"${want}"*) ;;
            *) bad+="${f}: ${desc}"$'\n' ;;
        esac
    done
    if [ -n "${bad}" ]; then
        echo "wrong architecture (expected ${want}):" >&2
        printf '%s' "${bad}" >&2
        exit 1
    fi
fi

zip_args=("${payload[@]}")
if [ -d "dist/pkg-${target}" ]; then
    zip_args+=("dist/pkg-${target}")
fi

rm -v "${dist_file}" || true
zip -rj "${dist_file}" "${zip_args[@]}" -x \*.DS_Store -x \*.gitkeep
