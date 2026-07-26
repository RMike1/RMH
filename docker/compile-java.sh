set -euo pipefail

if [[ "${1:-}" == "--inside" ]]; then
  shift
  cd /work

  OUT=/work/web/WEB-INF/classes
  CP="/usr/local/tomcat/lib/servlet-api.jar:/work/web/WEB-INF/lib/*:$OUT"
  mkdir -p "$OUT"

  SOURCES=()
  if [[ $# -eq 0 ]]; then
    while IFS= read -r f; do
      SOURCES+=("$f")
    done < <(find src -name '*.java' | sort)
  else
    for arg in "$@"; do
      arg="${arg//\\//}"
      SOURCES+=("$arg")
    done
  fi

  if [[ ${#SOURCES[@]} -eq 0 ]]; then
    echo "No .java files to compile."
    exit 1
  fi

  echo "==> Using $(javac -version 2>&1) (container tomcat:8.5-jdk8)"
  echo "==> Compiling ${#SOURCES[@]} file(s) -> web/WEB-INF/classes/"
  javac -encoding ISO-8859-1 -cp "$CP" -d "$OUT" "${SOURCES[@]}"

  echo "==> Done. Restart Tomcat to load new classes:"
  echo "  docker compose restart tomcat"
  exit 0
fi

# --- host launcher ---
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required (and Docker Desktop must be running)."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker daemon is not reachable. Start Docker Desktop and retry."
  exit 1
fi

echo "==> Compiling inside tomcat:8.5-jdk8 (no host JDK needed)"
docker run --rm \
  --platform linux/amd64 \
  -v "$ROOT:/work" \
  -w /work \
  tomcat:8.5-jdk8 \
  bash /work/docker/compile-java.sh --inside "$@"
