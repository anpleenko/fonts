#!/bin/bash

# Path to font-patcher (specify the correct path)
FONT_PATCHER="./patcher/font-patcher"

# Base directory for output files
OUTPUT_BASE="fonts"

# List of directories to exclude (using | for regex)
EXCLUDE_DIRS="Roboto|Inter|FiraSans|Ubuntu|UbuntuSans"

echo "Checking dependencies..."
if ! command -v fontforge &>/dev/null; then
    echo "Fontforge is not installed. Please install Fontforge before continuing."
    exit 1
fi

# Function to remove existing NerdFont directories
clean_nerdfont_dirs() {
    echo "Cleaning old NerdFont directories..."
    find "$OUTPUT_BASE" -type d -name "*NerdFont" -exec rm -rf {} +
    echo "Cleanup completed."
}

# Function to create Nerd Font versions
patch_fonts() {
    local font_dir="$1"
    local font_family=$(basename "$font_dir")
    local output_dir="${OUTPUT_BASE}/${font_family}NerdFont"

    # Create output directory
    mkdir -p "$output_dir"

    # Process each font file in the directory
    for font_file in "$font_dir"/*.ttf; do
        if [ -f "$font_file" ]; then
            local font_name=$(basename "$font_file" .ttf)
            local output_file="${output_dir}/${font_name} Nerd Font.ttf"

            echo "Processing: $font_file -> $output_file"

            # Run font-patcher
            fontforge --script "$FONT_PATCHER" -c -q --outputdir "$output_dir" "$font_file"

            # Rename output file (font-patcher adds " Nerd Font" to the name)
            mv "${output_dir}/$(basename "$font_file" .ttf) Nerd Font.ttf" "$output_file" 2>/dev/null
        fi
    done
}

# Main logic
clean_nerdfont_dirs

# Process all font families except excluded and NerdFont ones
for font_family_dir in "$OUTPUT_BASE"/*/; do
    font_family=$(basename "$font_family_dir")

    # Check if this directory should be skipped
    if [[ "$font_family" =~ ^($EXCLUDE_DIRS)$ ]]; then
        echo "Skipping excluded directory: $font_family"
        continue
    fi

    if [[ "$font_family" != *"NerdFont"* ]]; then
        echo "Processing font family: $font_family"
        patch_fonts "$font_family_dir"
    fi
done

echo "Done! All fonts have been processed."
