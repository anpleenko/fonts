#!/usr/bin/env bash

if ! command -v fontforge &>/dev/null; then
  echo "Fontforge is not installed. Please install Fontforge before continuing."
  exit 1
fi

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

if ! command -v zip &>/dev/null; then
  echo "zip is not installed. Please install zip before continuing."
  exit 1
fi

if ! command -v wget &>/dev/null; then
  echo "wget is not installed. Please install wget before continuing."
  exit 1
fi

if ! command -v unzip &>/dev/null; then
  echo "unzip is not installed. Please install unzip before continuing."
  exit 1
fi
