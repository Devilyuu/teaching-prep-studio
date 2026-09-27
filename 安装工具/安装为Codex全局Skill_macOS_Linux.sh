#!/usr/bin/env bash
set -e
# Codex 读取的是 ~/.codex/skills/（2026-09 实测）；旧版脚本写的 ~/.agents/skills 不会被读取
SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$HOME/.codex/skills/teaching-prep-studio"
mkdir -p "$(dirname "$TARGET")"
rm -rf "$TARGET"
cp -R "$SOURCE" "$TARGET"
rm -rf "$TARGET/.git"
echo "已安装到: $TARGET"
echo "想让 Codex 始终用仓库最新版，可改用符号链接：ln -s \"$SOURCE\" \"$TARGET\"（先删掉上面复制出来的目录）"
echo "请重启 Codex。"
