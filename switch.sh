#!/usr/bin/env bash
set -e

PROFILES_DIR="$HOME/.config/opencode-profiles/profiles"
TARGET_DIR="$HOME/.config/opencode"
PROFILE="$1"

if [ -z "$PROFILE" ] || [ ! -d "$PROFILES_DIR/$PROFILE" ]; then
  echo "Доступные профили:"
  ls -1 "$PROFILES_DIR"
  exit 1
fi

# Если ~/.config/opencode — обычная папка (создалась при первом запуске), сохраняем бэкап
if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
  mv "$TARGET_DIR" "${TARGET_DIR}.bak"
fi

rm -f "$TARGET_DIR"
ln -s "$PROFILES_DIR/$PROFILE" "$TARGET_DIR"
echo "Активный профиль OpenCode: $PROFILE"
