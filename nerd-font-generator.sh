#!/bin/bash

# Путь к font-patcher (укажите правильный путь)
FONT_PATCHER="./patcher/font-patcher"

# Базовый каталог для выходных файлов
OUTPUT_BASE="fonts"

# Функция для удаления существующих NerdFont папок
clean_nerdfont_dirs() {
    echo "Очистка старых NerdFont директорий..."
    find "$OUTPUT_BASE" -type d -name "*NerdFont" -exec rm -rf {} +
    echo "Очистка завершена."
}

# Функция для создания Nerd Font версий
patch_fonts() {
    local font_dir="$1"
    local font_family=$(basename "$font_dir")
    local output_dir="${OUTPUT_BASE}/${font_family}NerdFont"
    
    # Создаем директорию для выходных файлов
    mkdir -p "$output_dir"
    
    # Обрабатываем каждый файл шрифта в директории
    for font_file in "$font_dir"/*.ttf; do
        if [ -f "$font_file" ]; then
            local font_name=$(basename "$font_file" .ttf)
            local output_file="${output_dir}/${font_name} Nerd Font.ttf"
            
            echo "Обработка: $font_file -> $output_file"
            
            # Запускаем font-patcher
            fontforge --script "$FONT_PATCHER" -c --outputdir "$output_dir" "$font_file"
            
            # Переименовываем выходной файл (font-patcher добавляет " Nerd Font" к имени)
            mv "${output_dir}/$(basename "$font_file" .ttf) Nerd Font.ttf" "$output_file" 2>/dev/null
        fi
    done
}

# Основная логика
clean_nerdfont_dirs

# Обрабатываем все семейства шрифтов, кроме NerdFont
for font_family_dir in "$OUTPUT_BASE"/*/; do
    if [[ "$font_family_dir" != *"NerdFont"* ]]; then
        echo "Обработка семейства шрифтов: $font_family_dir"
        patch_fonts "$font_family_dir"
    fi
done

echo "Готово! Все шрифты были обработаны."
