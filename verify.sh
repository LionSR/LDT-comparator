#!/bin/bash
# Verify, with the official leanprover/comparator, that the MIPStarRE library
# proves exactly the theorem stated in Challenge.lean using only the axioms
# propext, Quot.sound, Classical.choice.
#
# Requires Linux with Landlock (kernel >= 5.13), Go, Rust, jq, and elan.
# On macOS there is no Landlock: pass --fake-landrun for a functional
# (non-sandboxed) check using comparator's official development stub.
set -euxo pipefail
cd "$(dirname "$0")"

TOOLCHAIN_TAG=$(sed 's/.*://' lean-toolchain)
LANDRUN_REV="v0.1.15"
NANODA_REV="v0.3.2"

CONFIG=comparator.json
if [ "${1:-}" = "--fake-landrun" ]; then
  jq '.enable_nanoda = false' comparator.json > comparator.local.json
  CONFIG=comparator.local.json
fi

if [ ! -x comparator/.lake/build/bin/comparator ]; then
  git clone --depth 1 --branch "$TOOLCHAIN_TAG" https://github.com/leanprover/comparator
  (cd comparator && lake build lean4export comparator)
fi
export PATH="$PWD/comparator/.lake/build/bin:$PWD/comparator/.lake/packages/lean4export/.lake/build/bin:$PATH"

if [ "${1:-}" = "--fake-landrun" ]; then
  export COMPARATOR_LANDRUN="$PWD/comparator/scripts/fake-landrun.sh"
else
  if [ ! -x landrun/landrun ]; then
    git clone --depth 1 --branch "$LANDRUN_REV" https://github.com/Zouuup/landrun
    (cd landrun && go build -o landrun ./cmd/landrun)
  fi
  export PATH="$PWD/landrun:$PATH"
  if [ ! -x nanoda_lib/target/release/nanoda_bin ]; then
    git clone --depth 1 --branch "$NANODA_REV" https://github.com/ammkrn/nanoda_lib
    (cd nanoda_lib && cargo build --release)
  fi
  export PATH="$PWD/nanoda_lib/target/release:$PATH"
fi

lake exe cache get || true
lake env comparator "$CONFIG"
