#!/bin/bash

# Make sure you have the required dependencies installed
echo "Checking dependencies..."
if ! command -v node &>/dev/null; then
  echo "Node.js is not installed. Please install Node.js before continuing."
  exit 1
fi

if ! command -v npm &>/dev/null; then
  echo "npm is not installed. Please install npm before continuing."
  exit 1
fi

if ! command -v ttfautohint &>/dev/null; then
  echo "ttfautohint is not installed. Please install ttfautohint before continuing."
  exit 1
fi

# Clone the Iosevka repository (if not already cloned)
if [ ! -d ".iosevka" ]; then
  echo "Cloning Iosevka repository..."
  git clone --depth=1 https://github.com/be5invis/Iosevka.git .iosevka
  cd .iosevka || exit
else
  cd .iosevka || exit
  git pull
fi

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
cp -r .iosevka/dist/Iosevka/TTF fonts/Iosevka

# Done
echo "Build completed! Fonts are located in:"
echo "$(pwd)/dist/"
