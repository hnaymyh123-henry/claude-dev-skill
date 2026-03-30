#!/bin/bash
# /dev skill installer for Claude Code
# Usage:
#   bash install.sh --lang en   # install English version
#   bash install.sh --lang zh   # install Chinese version

set -e

LANG_FLAG="en"

for arg in "$@"; do
  case $arg in
    --lang=*) LANG_FLAG="${arg#*=}" ;;
    --lang)   shift; LANG_FLAG="$1" ;;
  esac
done

if [[ "$LANG_FLAG" != "en" && "$LANG_FLAG" != "zh" ]]; then
  echo "Usage: bash install.sh --lang en|zh"
  exit 1
fi

SRC="./$LANG_FLAG/commands"
DEST="$HOME/.claude/commands"

echo "Installing /dev skill ($LANG_FLAG) to $DEST ..."

mkdir -p "$DEST/dev"

cp "$SRC/dev.md"                         "$DEST/dev.md"
cp "$SRC/dev/phase1.md"                  "$DEST/dev/phase1.md"
cp "$SRC/dev/phase2.md"                  "$DEST/dev/phase2.md"
cp "$SRC/dev/phase3.md"                  "$DEST/dev/phase3.md"
cp "$SRC/dev/phase3.5.md"               "$DEST/dev/phase3.5.md"
cp "$SRC/dev/phase4.md"                  "$DEST/dev/phase4.md"
cp "$SRC/dev/phase5.md"                  "$DEST/dev/phase5.md"
cp "$SRC/dev/worker-new.md"              "$DEST/dev/worker-new.md"
cp "$SRC/dev/worker-fix.md"              "$DEST/dev/worker-fix.md"
cp "$SRC/dev/qa-agent.md"               "$DEST/dev/qa-agent.md"
cp "$SRC/dev/PROJECT_CONTEXT_TEMPLATE.md" "$DEST/dev/PROJECT_CONTEXT_TEMPLATE.md"

echo ""
echo "✓ Done! Open Claude Code and type /dev to get started."
