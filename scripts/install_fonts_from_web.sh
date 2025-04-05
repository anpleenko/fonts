#!/bin/bash

# Проверка на root-права (скрипт требует sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Этот скрипт должен запускаться с правами root (используйте sudo)"
  exit 1
fi

FONTS_DIR="/usr/local/share/fonts"
FONTS_ZIP_URL="https://github.com/anpleenko/fonts/releases/download/latest/linux-fonts.zip"
TEMP_ZIP="/tmp/linux-fonts.zip"

# Установка зависимостей (если нужно)
if ! command -v unzip &>/dev/null; then
  echo "Устанавливаем unzip..."
  apt-get install -y unzip || yum install -y unzip || {
    echo "Не удалось установить unzip. Установите его вручную."
    exit 1
  }
fi

if ! command -v wget &>/dev/null; then
  echo "Устанавливаем wget..."
  apt-get install -y wget || yum install -y wget || {
    echo "Не удалось установить wget. Установите его вручную."
    exit 1
  }
fi

# Создание папки со шрифтами (если нет)
echo "Создаем папку $FONTS_DIR (если её нет)..."
mkdir -p "$FONTS_DIR"

# Очистка папки со шрифтами
echo "Очищаем папку $FONTS_DIR..."
rm -rf "${FONTS_DIR:?}/"*

# Скачивание архива
echo "Скачиваем шрифты с $FONTS_ZIP_URL..."
if ! wget -q "$FONTS_ZIP_URL" -O "$TEMP_ZIP"; then
  echo "Ошибка при скачивании архива со шрифтами!"
  exit 1
fi

# Проверка скачанного файла
if [ ! -s "$TEMP_ZIP" ]; then
  echo "Ошибка: скачанный файл пустой или не существует!"
  exit 1
fi

# Распаковка архива
echo "Распаковываем шрифты в $FONTS_DIR..."
if ! unzip -q -o "$TEMP_ZIP" -d "$FONTS_DIR"; then
  echo "Ошибка при распаковке архива!"
  exit 1
fi

# Удаление временного файла
rm -f "$TEMP_ZIP"

# Обновление кэша шрифтов
echo "Обновляем кэш шрифтов..."
fc-cache -fv

echo "Готово! Шрифты успешно установлены в $FONTS_DIR"
