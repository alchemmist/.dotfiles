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

# Создаем временный файл
temp_file=$(mktemp --suffix=.png)

# Обрабатываем каждый файл изображения
for input_file in "${image_files[@]}"; do
    echo "Обработка: $input_file"
    
    # Извлекаем имя файла без расширения
    filename_without_extension="${input_file%.*}"
    
    # 1. Конвертируем в PNG (если нужно) и применяем радиус
    if [[ "$input_file" == *.png ]]; then
        # Для PNG используем напрямую
        "$radius_script" "$input_file" "$temp_file"
    else
        # Конвертируем в PNG через ImageMagick
        magick "$input_file" png:- | "$radius_script" - "$temp_file"
    fi
    
    # 2. Применяем тень
    output_file="$preview_dir/$filename_without_extension.png"
    "$shadow_script" "$temp_file" "$output_file"
    
    # 3. Добавляем запись в README.md
    {
        echo "[$input_file](https://github.com/alchemmist/dotfiles/blob/main/wallpapers/$current_dir_name/$input_file)<br>"
        echo "<img src=\"/media/wlp-preview/$current_dir_name/$filename_without_extension.png\" width=\"500\">"
        echo ""
    } >> "README.md"
done

# Удаляем временный файл
rm -f "$temp_file"

echo "Готово! Обработано ${#image_files[@]} изображений."
echo "Превью сохранены в: $preview_dir"
echo "Записи добавлены в README.md"
