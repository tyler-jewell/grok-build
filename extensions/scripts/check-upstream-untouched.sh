#!/usr/bin/env bash
# Fail if this fork has modified, deleted, or renamed any path that exists
# on upstream/main. Adding files that upstream does not have is allowed.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

UPSTREAM_REMOTE="${UPSTREAM_REMOTE:-upstream}"
UPSTREAM_URL="${UPSTREAM_URL:-https://github.com/xai-org/grok-build.git}"
UPSTREAM_REF="${UPSTREAM_REF:-}"

if [[ -z "$UPSTREAM_REF" ]]; then
  if git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
    git fetch --quiet "$UPSTREAM_REMOTE" main
    UPSTREAM_REF="${UPSTREAM_REMOTE}/main"
  else
    git fetch --quiet "$UPSTREAM_URL" main
    UPSTREAM_REF="FETCH_HEAD"
  fi
fi

if ! git rev-parse --verify "$UPSTREAM_REF" >/dev/null 2>&1; then
  echo "error: cannot resolve $UPSTREAM_REF" >&2
  exit 2
fi

overlap="$(comm -12 \
  <(git ls-tree -r --name-only "$UPSTREAM_REF" | sort -u) \
  <(git diff --name-only "${UPSTREAM_REF}...HEAD" | sort -u) \
  || true)"

if [[ -n "$overlap" ]]; then
  echo "error: these paths exist on upstream/main and were changed on this fork:" >&2
  printf '%s\n' "$overlap" >&2
  echo >&2
  echo "Revert them. Only add files under AGENTS.md, .grok/, .github/, or extensions/." >&2
  exit 1
fi

echo "ok: no upstream-owned paths changed vs ${UPSTREAM_REF}"
