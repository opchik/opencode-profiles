#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILES_DIR="$REPO_DIR/profiles"
SHARED_DIR="$REPO_DIR/shared"
TARGET_DIR="$HOME/.config/opencode"
PROFILE="${1:-}"

if [ -z "$PROFILE" ] || [ ! -d "$PROFILES_DIR/$PROFILE" ]; then
  echo "Доступные профили:"
  ls -1 "$PROFILES_DIR"
  exit 1
fi

command -v jq >/dev/null 2>&1 || {
  echo "Ошибка: требуется jq для сборки конфига."
  exit 1
}

# Личный конфиг (провайдер/модель/url/key) создаём из шаблона при первом переключении
if [ ! -f "$PROFILES_DIR/$PROFILE/opencode.local.json" ]; then
  cp "$SHARED_DIR/opencode.local.example.json" "$PROFILES_DIR/$PROFILE/opencode.local.json"
  echo "Создан личный конфиг: $PROFILES_DIR/$PROFILE/opencode.local.json"
  echo "Заполните его под свой эндпоинт и модель (url/key берутся из ~/.deepseek.url и ~/.deepseek.key)."
fi

# Если ~/.config/opencode — обычная папка (создалась при первом запуске), сохраняем бэкап
if [ -e "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
  rm -rf "${TARGET_DIR}.bak"
  mv "$TARGET_DIR" "${TARGET_DIR}.bak"
fi

# Итоговый конфиг = base + профиль + личный (deep-merge, последний перезаписывает)
jq -s 'reduce .[] as $i ({}; . * $i)' \
  "$SHARED_DIR/base.json" \
  "$PROFILES_DIR/$PROFILE/opencode.profile.json" \
  "$PROFILES_DIR/$PROFILE/opencode.local.json" \
  > "$PROFILES_DIR/$PROFILE/opencode.json"

rm -f "$TARGET_DIR"
ln -s "$PROFILES_DIR/$PROFILE" "$TARGET_DIR"
echo "Активный профиль OpenCode: $PROFILE"
