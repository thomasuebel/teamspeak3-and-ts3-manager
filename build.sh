#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="$SCRIPT_DIR/Apps"

for app_dir in "$APPS_DIR"/*/; do
    app_name="$(basename "$app_dir")"
    cd "$SCRIPT_DIR"

    # Flat zip for general use
    zip_file="${app_name}.zip"
    echo "Building $zip_file..."
    zip -j "$zip_file" "docker-compose.yml" "Apps/$app_name/app.json"
    echo "Done: $zip_file"

    # CasaOS zip — requires Apps/<app-name>/ folder structure inside the zip
    casaos_zip_file="${app_name}-casaos.zip"
    echo "Building $casaos_zip_file..."
    cp "docker-compose.yml" "Apps/$app_name/docker-compose.yml"
    zip "$casaos_zip_file" "Apps/$app_name/docker-compose.yml" "Apps/$app_name/app.json"
    rm "Apps/$app_name/docker-compose.yml"
    echo "Done: $casaos_zip_file"
done
