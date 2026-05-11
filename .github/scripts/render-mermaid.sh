#!/usr/bin/env bash
# Re-render every docs/architecture/*.mmd to a sibling .svg using the
# minlag/mermaid-cli docker image. Same image is used in CI; same image is
# used locally; SVG output stays byte-identical so the diff gate is trustable.
set -euo pipefail

IMAGE="${MERMAID_CLI_IMAGE:-minlag/mermaid-cli:latest}"

for f in docs/architecture/*.mmd; do
  [ -f "$f" ] || continue
  echo "rendering $f"
  docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/data" "$IMAGE" \
    -i "/data/$f" -o "/data/${f%.mmd}.svg" --quiet
done
