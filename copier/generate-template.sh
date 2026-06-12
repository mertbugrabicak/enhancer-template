#!/usr/bin/env bash

set -e

# ==========================================
# Dynamic Directory Resolution
# ==========================================
# Gets the absolute path of the 'copier' folder, regardless of where the script is run from
COPIER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Resolves the root project directory (one level up from 'copier')
ROOT_DIR="$(dirname "$COPIER_DIR")"

OUTPUT_ROOT="$COPIER_DIR/generated_template"
TEMPLATE_DIR="$OUTPUT_ROOT/template"

echo "--- 🧹 Cleaning up old generated template ---"
rm -rf "$OUTPUT_ROOT"
mkdir -p "$TEMPLATE_DIR"

echo "--- 📄 Setting up copier.yml ---"
if [ -f "$COPIER_DIR/copier.yml" ]; then
    cp "$COPIER_DIR/copier.yml" "$OUTPUT_ROOT/"
else
    echo "⚠️ ERROR: copier.yml not found inside $COPIER_DIR!"
    exit 1
fi

echo "--- 📦 Copying source code ---"
# Use rsync from the ROOT directory, excluding the copier folder and build artifacts
rsync -a --exclude=".git" \
         --exclude="target" \
         --exclude=".idea" \
         --exclude=".vscode" \
         --exclude="example-enhancer.iml" \
         --exclude="copier" \
         --exclude="tmp" \
         "$ROOT_DIR/" "$TEMPLATE_DIR/"

echo "--- 📝 Injecting Copier variables into files ---"
find "$TEMPLATE_DIR" -type f -exec sed -i.bak "s/Example Enhancer/{{ project_name }}/g" {} +
find "$TEMPLATE_DIR" -type f -exec sed -i.bak "s/example-enhancer/{{ project_slug }}/g" {} +
find "$TEMPLATE_DIR" -type f -exec sed -i.bak "s/exampleenhancer/{{ project_slug | replace('-', '') }}/g" {} +

# Clean up the backup files created by sed
find "$TEMPLATE_DIR" -name "*.bak" -type f -delete

echo "--- 📂 Renaming files and directories ---"
find "$TEMPLATE_DIR" -depth -name "*example-enhancer*" | while read -r item; do
    new_item=$(echo "$item" | sed "s/example-enhancer/{{ project_slug }}/g")
    mv "$item" "$new_item"
done

find "$TEMPLATE_DIR" -depth -name "*exampleenhancer*" | while read -r item; do
    new_item=$(echo "$item" | sed "s/exampleenhancer/{{ project_slug | replace('-', '') }}/g")
    mv "$item" "$new_item"
done

echo "--- ✅ Template generation complete! ---"
echo "Your Copier template is ready inside: $OUTPUT_ROOT"