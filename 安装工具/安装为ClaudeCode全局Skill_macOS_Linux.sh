#!/usr/bin/env bash
set -e
SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$HOME/.claude/skills/teaching-prep-studio"
mkdir -p "$(dirname "$TARGET")"
rm -rf "$TARGET"
cp -R "$SOURCE" "$TARGET"
rm -rf "$TARGET/.git"
echo "已安装到: $TARGET"
echo "请重启 Claude Code。"
