#!/usr/bin/env bash
# Build the ChatGPT plugin ZIP from a commit, without the "## No account yet"
# section. The ChatGPT build keeps the skill text OpenAI last reviewed: its
# review rejected links in the skill twice, so the no-account line (and its
# links) ships to Claude Code, Cursor and Gemini only.
#
# Usage: scripts/build-chatgpt-zip.sh [ref] [out.zip]
#   ref     commit to package (default: main)
#   out.zip output path (default: ./isms-copilot-chatgpt-<version>.zip)
set -euo pipefail

ref="${1:-main}"
version="$(git show "${ref}:plugin.json" | sed -n 's/^  "version": "\(.*\)",$/\1/p')"
out="${2:-isms-copilot-chatgpt-${version}.zip}"
case "$out" in /*) ;; *) out="$PWD/$out" ;; esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git archive "$ref" | tar -x -C "$tmp"

# Drop the section from its heading to the end of the file, and the blank
# lines before it, in every Markdown file that carries it.
grep -rl --include='*.md' '^## No account yet$' "$tmp" | while read -r f; do
  perl -0pi -e 's/\n+## No account yet\n.*\z/\n/s' "$f"
done

if grep -rq 'chat\.ismscopilot\.com' "$tmp"; then
  echo "build-chatgpt-zip: chat.ismscopilot.com is still in the package:" >&2
  grep -rl 'chat\.ismscopilot\.com' "$tmp" >&2
  exit 1
fi

rm -f "$out"
(cd "$tmp" && zip -qr -X "$out" .)
echo "$out (from $(git rev-parse --short "$ref"), version $version)"
