#!/usr/bin/env bash
# Read-only example script. Prints a greeting using assets/greeting.txt.
# Usage: scripts/hello.sh [name]
set -euo pipefail

name="${1:-World}"
template_path="$(dirname "$0")/../assets/greeting.txt"

if [[ ! -f "$template_path" ]]; then
  echo "error: template not found at $template_path" >&2
  exit 1
fi

sed "s/{{name}}/$name/" "$template_path"
