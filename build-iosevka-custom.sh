#!/bin/bash

# Убедитесь, что у вас установлены необходимые зависимости
echo "Проверка зависимостей..."
if ! command -v node &>/dev/null; then
  echo "Node.js не установлен. Установите Node.js перед продолжением."
  exit 1
fi

if ! command -v npm &>/dev/null; then
  echo "npm не установлен. Установите npm перед продолжением."
  exit 1
fi

# Клонируем репозиторий Iosevka (если ещё не клонирован)
if [ ! -d "iosevka" ]; then
  echo "Клонирование репозитория Iosevka..."
  git clone --depth=1 https://github.com/be5invis/Iosevka.git iosevka
  cd iosevka || exit
else
  cd iosevka || exit
  git pull
fi

# Устанавливаем зависимости
echo "Установка зависимостей..."
npm install

# Копируем ваш файл конфигурации
echo "Копирование private-build-plans.toml..."
cp ../private-build-plans.toml .

# Собираем шрифт
echo "Запуск сборки шрифта..."
npm run build -- ttf::Iosevka

echo "Меняем директорию"
cd ..

echo "Удаляем старую директорию шрифта Iosevka"
find fonts -type d -name "Iosevka" -exec rm -rf {} +

echo "Копируем новый фалы шрифта Iosevka"
cp -r iosevka/dist/Iosevka/TTF fonts/Iosevka

# Готово
echo "Сборка завершена! Шрифты находятся в:"
echo "$(pwd)/dist/"
