#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="$SCRIPT_DIR/Apps"

for app_dir in "$APPS_DIR"/*/; do
    app_name="$(basename "$app_dir")"
    zip_file="$SCRIPT_DIR/${app_name}.zip"

    echo "Building $zip_file..."
    cd "$SCRIPT_DIR"
    zip -j "$zip_file" "docker-compose.yml" "Apps/$app_name/app.json"
    echo "Done: $zip_file"
done
