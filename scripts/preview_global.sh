#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${PREVIEW_PORT:-8765}"
MAIN="${PREVIEW_MAIN:-lib/global_preview_main.dart}"
TUNNEL="${PREVIEW_TUNNEL:-localhost.run}"

cd "$ROOT"

echo ">> Building Flutter Web ($MAIN)..."
flutter build web -t "$MAIN" --release

lsof -ti :"$PORT" | xargs kill -9 2>/dev/null || true

echo ">> Starting static server on http://127.0.0.1:$PORT ..."
python3 -m http.server "$PORT" --directory build/web &
SERVER_PID=$!

cleanup() {
  kill "$SERVER_PID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 1

LAN_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"
if [[ -n "$LAN_IP" ]]; then
  echo ">> LAN preview: http://${LAN_IP}:${PORT}"
fi

echo ">> Creating public tunnel ($TUNNEL)..."
case "$TUNNEL" in
  localhost.run)
    echo ">> Waiting for tunnel URL..."
    ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 \
      -R "80:127.0.0.1:${PORT}" nokey@localhost.run 2>&1 | while IFS= read -r line; do
      echo "$line"
      if [[ "$line" =~ https://[a-z0-9-]+\.lhr\.life ]]; then
        echo ""
        echo ">> Public preview ready (no password page): ${BASH_REMATCH[0]}"
      fi
    done
    ;;
  localtunnel|*)
    echo ">> Note: loca.lt may require IP verification and can be blocked in some regions."
    npx -y localtunnel --port "$PORT"
    ;;
esac
