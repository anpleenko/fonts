#!/usr/bin/env bash

if [ -d "Iosevka-main" ]; then
  rm -rf Iosevka-main
fi

echo "Get latest Iosevka source..."
wget https://github.com/be5invis/Iosevka/archive/refs/heads/main.zip
unzip main.zip
rm main.zip

echo "Changing directory"
cd Iosevka-main

# Install dependencies
echo "Installing dependencies..."
npm install

# Copy your configuration file
echo "Copying private-build-plans.toml..."
cp ../private-build-plans.toml .

# Build the font
echo "Running font build..."
npm run build -- ttf::Iosevka

echo "Changing directory"
cd ..

echo "Removing old Iosevka font directory"
rm -rf fonts/Iosevka

echo "Copying new Iosevka font files"
cp -r Iosevka-main/dist/Iosevka/TTF fonts/Iosevka

# Done
echo "Build completed! Fonts are located in:"
echo "$(pwd)/dist/"

echo "Removing Iosevka repo directory"
rm -rf Iosevka-main
