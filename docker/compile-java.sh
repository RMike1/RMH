#!/usr/bin/env bash
# Compile Java under src/ into web/WEB-INF/classes targeting Java 8
# (matches Docker Tomcat 8). Does not delete existing classes (keeps be/).
#
# Usage:
#   ./docker/compile-java.sh
#   ./docker/compile-java.sh src/training/Hello.java
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

pick_jdk() {
  local ver home major
  for ver in 1.8 8 11; do
    home="$(/usr/libexec/java_home -v "$ver" 2>/dev/null || true)"
    [[ -n "$home" ]] || continue
    major="$("$home/bin/java" -version 2>&1 | awk -F[\".] '/version/ {print ($2=="1"?$3:$2); exit}')"
    if [[ "$ver" == "1.8" || "$ver" == "8" ]]; then
      if [[ "$major" == "8" ]]; then
        echo "$home|8"
        return 0
      fi
      continue
    fi
    if [[ "$ver" == "11" && "$major" == "11" ]]; then
      echo "$home|11"
      return 0
    fi
  done
  return 1
}

PICK="$(pick_jdk || true)"
if [[ -z "$PICK" ]]; then
  echo "Need a real JDK 8 (preferred) or JDK 11 to compile for Tomcat 8."
  echo "  brew install --cask temurin@8"
  echo "Note: on this Mac, java_home -v 1.8 may wrongly return a newer JDK — we verify the version."
  exit 1
fi

JAVA_HOME="${PICK%%|*}"
JDK_MAJOR="${PICK##*|}"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

RELEASE_ARGS=()
if [[ "$JDK_MAJOR" == "11" ]]; then
  RELEASE_ARGS=(--release 8)
fi

if [[ ${#RELEASE_ARGS[@]} -gt 0 ]]; then
  echo "==> Using $(javac -version 2>&1) ($JAVA_HOME) ${RELEASE_ARGS[*]}"
else
  echo "==> Using $(javac -version 2>&1) ($JAVA_HOME)"
fi

OUT="$ROOT/web/WEB-INF/classes"
CP="$ROOT/web/WEB-INF/lib/*:$OUT"

# Servlet API is provided by Tomcat, not WEB-INF/lib
SERVLET_API=""
if [[ -f /tmp/openclinic-servlet-api.jar ]]; then
  SERVLET_API=/tmp/openclinic-servlet-api.jar
elif command -v docker >/dev/null 2>&1; then
  if docker cp openclinic-tomcat:/usr/local/tomcat/lib/servlet-api.jar /tmp/openclinic-servlet-api.jar 2>/dev/null; then
    SERVLET_API=/tmp/openclinic-servlet-api.jar
  fi
fi
if [[ -n "$SERVLET_API" ]]; then
  CP="$SERVLET_API:$CP"
fi

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
if [[ ${#RELEASE_ARGS[@]} -gt 0 ]]; then
  javac -encoding ISO-8859-1 "${RELEASE_ARGS[@]}" -cp "$CP" -d "$OUT" "${SOURCES[@]}"
else
  javac -encoding ISO-8859-1 -cp "$CP" -d "$OUT" "${SOURCES[@]}"
fi

echo "==> Done. Restart Tomcat to load new classes:"
echo "  docker compose restart tomcat"
