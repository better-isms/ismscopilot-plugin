#!/usr/bin/env bash
# Build the ChatGPT plugin ZIP from a commit, keeping the text OpenAI last
# reviewed. Its review rejected links in the package twice, so the
# no-account line (and its links) ships to Claude Code, Cursor and Gemini
# only (decision A6 of the logged-out agent access design).
#
# Fail-closed: after the strip below, every file must be byte-identical to
# the last submitted commit (LAST_SUBMITTED), and the four manifests may
# differ only in their "version" line. Anything else stops the build. When
# a new ChatGPT package is approved and submitted, move LAST_SUBMITTED to
# that commit in the same pull request.
#
# Usage: scripts/build-chatgpt-zip.sh [ref] [out.zip]
#   ref     commit to package (default: main)
#   out.zip output path (default: ./isms-copilot-chatgpt-<version>.zip)
set -euo pipefail

LAST_SUBMITTED=c989da3   # 0.1.8, submitted 2026-11-04
MANIFESTS=(plugin.json .claude-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json)
# Maintainer notes whose newer entries describe changes ChatGPT does not get:
# the ZIP carries the copies from LAST_SUBMITTED.
NOTES=(README.md CHANGELOG.md)

ref="${1:-main}"
version="$(git show "${ref}:plugin.json" | sed -n 's/^  "version": "\(.*\)",$/\1/p')"
if [ -z "$version" ]; then
  echo "build-chatgpt-zip: no version found in ${ref}:plugin.json" >&2
  exit 1
fi
out="${2:-isms-copilot-chatgpt-${version}.zip}"
case "$out" in /*) ;; *) out="$PWD/$out" ;; esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/pkg" "$tmp/base"
git archive "$ref" | tar -x -C "$tmp/pkg"
git archive "$LAST_SUBMITTED" | tar -x -C "$tmp/base"

# Drop every "## No account yet" section (heading to end of file, and the
# blank lines before it) from the Markdown files that carry one.
for dir in "$tmp/pkg" "$tmp/base"; do
  { grep -rl --include='*.md' '^## No account yet$' "$dir" || true; } | while read -r f; do
    perl -0pi -e 's/\n+## No account yet\n.*\z/\n/s' "$f"
  done
done
for f in "${NOTES[@]}"; do
  cp "$tmp/base/$f" "$tmp/pkg/$f"
done

# Same file list, same bytes; manifests compared with the version line masked.
mask() { sed 's/^\(  *"version": \)".*"/\1"X"/' "$1"; }
status=0
if ! diff <(cd "$tmp/base" && find . -type f | sort) <(cd "$tmp/pkg" && find . -type f | sort) >&2; then
  echo "build-chatgpt-zip: file list differs from $LAST_SUBMITTED" >&2
  status=1
fi
while read -r f; do
  [ -f "$tmp/base/$f" ] || continue
  case " ${MANIFESTS[*]} " in
    *" ${f#./} "*) diff <(mask "$tmp/base/$f") <(mask "$tmp/pkg/$f") >&2 || { echo "build-chatgpt-zip: $f differs beyond its version" >&2; status=1; } ;;
    *) cmp -s "$tmp/base/$f" "$tmp/pkg/$f" || { echo "build-chatgpt-zip: $f differs from $LAST_SUBMITTED" >&2; status=1; } ;;
  esac
done < <(cd "$tmp/pkg" && find . -type f | sort)
if [ "$status" -ne 0 ]; then
  echo "build-chatgpt-zip: refusing to build; the ChatGPT package must match $LAST_SUBMITTED except versions" >&2
  exit 1
fi

rm -f "$out"
(cd "$tmp/pkg" && zip -qr -X "$out" .)
echo "$out (from $(git rev-parse --short "$ref"), version $version, identical to $LAST_SUBMITTED except versions)"
