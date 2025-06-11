#!/usr/bin/env bash
set -euo pipefail

# Папка для скриншотов
OUT_DIR="$HOME/Pictures/screenshots"
mkdir -p "$OUT_DIR"

# Временные файлы
TMP1="$(mktemp -t shot_raw.XXXXXX.png)"
TMP2="$(mktemp -t shot_rounded.XXXXXX.png)"

# Финальное имя
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
FINAL="$OUT_DIR/$TIMESTAMP.png"

# Функция очистки
cleanup() {
  rm -f "$TMP1" "$TMP2"
}
trap cleanup EXIT

# 1. Делаем скриншот выбранной области
grim -g "$(slurp)" - > "$TMP1"

# 2. Обрезаем углы
"$HOME/scripts/png-radius.sh" "$TMP1" "$TMP2"

# 3. Добавляем тень и сохраняем в папку
"$HOME/scripts/png-shadow.sh" "$TMP2" "$FINAL"

# 4. Копируем в буфер обмена
wl-copy < "$FINAL"

echo "Скриншот сохранён в $FINAL и скопирован в буфер обмена."

