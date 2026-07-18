#!/usr/bin/env bash
# Compile Java under src/ into web/WEB-INF/classes using JDK 8 (matches Docker Tomcat 8).
# Does not delete existing classes (keeps be/).
#
# Usage:
#   ./docker/compile-java.sh
#   ./docker/compile-java.sh src/net/admin/User.java
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

JAVA_HOME=""
if JAVA_HOME="$(/usr/libexec/java_home -v 1.8 2>/dev/null)"; then
  :
elif JAVA_HOME="$(/usr/libexec/java_home -v 8 2>/dev/null)"; then
  :
else
  echo "JDK 8 not found. Docker Tomcat uses Java 8 — install Temurin 8, then retry."
  echo "  brew install --cask temurin@8"
  echo "Or compile only if you accept rebuilding with a newer JDK and a newer Tomcat image."
  exit 1
fi
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

echo "==> Using $(javac -version 2>&1) ($JAVA_HOME)"

OUT="$ROOT/web/WEB-INF/classes"
CP="$ROOT/web/WEB-INF/lib/*:$OUT"
mkdir -p "$OUT"

SOURCES=()
if [[ $# -eq 0 ]]; then
  while IFS= read -r f; do
    SOURCES+=("$f")
  done < <(find src -name '*.java' | sort)
else
  SOURCES=("$@")
fi

if [[ ${#SOURCES[@]} -eq 0 ]]; then
  echo "No .java files to compile."
  exit 1
fi

echo "==> Compiling ${#SOURCES[@]} file(s) -> web/WEB-INF/classes/"
javac -encoding ISO-8859-1 -cp "$CP" -d "$OUT" "${SOURCES[@]}"

echo "==> Done. Restart Tomcat to load new classes:"
echo "  docker compose restart tomcat"
