#!/usr/bin/env bash
# Watch src/**/*.java and compile only the changed file (JDK 8 via compile-java.sh).
# Safe for OpenClinic: does not wipe be/.
#
# Usage:
#   ./docker/watch-java.sh           # compile on save
#   ./docker/watch-java.sh --restart # also restart Tomcat after compile
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
COMPILE="$ROOT/docker/compile-java.sh"
RESTART=0

for arg in "$@"; do
  case "$arg" in
    --restart|-r) RESTART=1 ;;
    -h|--help)
      echo "Usage: $0 [--restart]"
      exit 0
      ;;
  esac
done

chmod +x "$COMPILE" 2>/dev/null || true

run_compile() {
  local file="$1"
  [[ -n "$file" && -f "$file" && "$file" == *.java ]] || return 0
  echo ""
  echo "==> Changed: $file"
  if "$COMPILE" "$file"; then
    if [[ "$RESTART" -eq 1 ]]; then
      echo "==> Restarting Tomcat..."
      docker compose restart tomcat
    else
      echo "==> Tip: docker compose restart tomcat  (or: $0 --restart)"
    fi
  else
    echo "==> Compile failed"
  fi
}

echo "==> Watching src/ for .java changes (Ctrl+C to stop)"
[[ "$RESTART" -eq 1 ]] && echo "==> Will restart Tomcat after each OK compile"

echo "==> Ready. Save a Java file to compile it automatically."
STAMP=$(mktemp)
trap 'rm -f "$STAMP"' EXIT
touch "$STAMP"
while true; do
  CHANGED=$(find src -name '*.java' -newer "$STAMP" 2>/dev/null || true)
  if [[ -n "$CHANGED" ]]; then
    touch "$STAMP"
    echo "$CHANGED" | while IFS= read -r f; do
      run_compile "$f"
    done
  fi
  sleep 2
done
