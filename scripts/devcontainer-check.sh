#!/usr/bin/env bash
# Acceptance check for the Blackburn dev container: CLI tests, launcher, xcross.
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
go test -race -count=1 ./...
bin/blackburn --help >/dev/null
bin/xcross --version
