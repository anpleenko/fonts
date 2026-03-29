#!/bin/bash

# Script to package each font directory into a separate zip archive
# Each archive will contain only the font files, without nested folders
# Archives will be placed in the dist directory

# Create dist directory if it doesn't exist
mkdir -p dist

# Get all font directories
font_dirs=$(find fonts -maxdepth 1 -type d -not -name "fonts")

# Process each font directory
for dir in $font_dirs; do
    # Get the font name (directory name without path)
    font_name=$(basename "$dir")
    
    # Create a temporary directory for this font
    temp_dir="temp_$font_name"
    mkdir -p "$temp_dir"
    
    # Copy all font files to the temporary directory
    cp "$dir"/* "$temp_dir"/
    
    # Create zip archive without nested folders
    zip -j "dist/$font_name.zip" "$temp_dir"/*
    
    # Clean up temporary directory
    rm -rf "$temp_dir"
    
    echo "Created $font_name.zip"
done

echo "All font packages created in dist directory"
