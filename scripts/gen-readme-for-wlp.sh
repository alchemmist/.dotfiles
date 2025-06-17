#!/bin/bash

# Включаем отладку
set -e

# Проверяем наличие README.md
if [ ! -f "README.md" ]; then
    echo "Ошибка: README.md не найден в текущей директории!"
    exit 1
fi

# Получаем имя текущей директории
current_dir_name=$(basename "$(pwd)")

# Пути для обработки изображений
radius_script="$HOME/scripts/png-radius.sh"
shadow_script="$HOME/scripts/png-shadow.sh"
preview_dir="$HOME/code/dotfiles/media/wlp-preview/$current_dir_name"

# Проверяем наличие скриптов обработки
if [ ! -f "$radius_script" ]; then
    echo "Ошибка: Скрипт png-radius.sh не найден!"
    exit 1
fi

if [ ! -f "$shadow_script" ]; then
    echo "Ошибка: Скрипт png-shadow.sh не найден!"
    exit 1
fi

# Проверяем наличие ImageMagick
if ! command -v magick &> /dev/null; then
    echo "Ошибка: ImageMagick (convert) не установлен!"
    echo "Установите его командой: sudo apt install imagemagick"
    exit 1
fi

# Создаем директорию для превью
mkdir -p "$preview_dir"

# Проверяем наличие файлов изображений
shopt -s nullglob
image_files=( *.{jpg,jpeg,png,webp,gif,bmp,tiff} )
if [ ${#image_files[@]} -eq 0 ]; then
    echo "Ошибка: В текущей директории нет файлов изображений!"
    exit 1
fi

echo "Найдено ${#image_files[@]} файлов изображений для обработки"

# Обрабатываем каждый файл изображения
for input_file in "${image_files[@]}"; do
    echo "Обработка: $input_file"
    
    # Извлекаем имя файла без расширения
    filename_without_extension="${input_file%.*}"
    
    # Создаем временные файлы
    temp_resized=$(mktemp --suffix=.png)
    temp_radius=$(mktemp --suffix=.png)
    
    # 1. Конвертируем в PNG и сжимаем до 600px по ширине
    magick "$input_file" -resize 600x -quality 90 -strip "$temp_resized"
    
    # 2. Применяем скрипт для закругления углов
    "$radius_script" "$temp_resized" "$temp_radius"
    
    # 3. Применяем скрипт для добавления тени
    output_file="$preview_dir/$filename_without_extension.png"
    "$shadow_script" "$temp_radius" "$output_file"
    
    # 4. Добавляем запись в README.md
    {
        echo "[$input_file](https://github.com/alchemmist/dotfiles/blob/main/wallpapers/$current_dir_name/$input_file)<br>"
        echo "<img src=\"/media/wlp-preview/$current_dir_name/$filename_without_extension.png\" width=\"500\">"
        echo ""
    } >> "README.md"
    
    # Удаляем временные файлы
    rm -f "$temp_resized" "$temp_radius"
done

echo "Готово! Обработано ${#image_files[@]} изображений."
echo "Оптимизированные превью сохранены в: $preview_dir"
echo "Записи добавлены в README.md"
