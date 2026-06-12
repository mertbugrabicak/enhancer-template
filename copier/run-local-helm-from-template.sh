#!/usr/bin/env bash

set -e

# ==========================================
# Dynamic Directory Resolution
# ==========================================
COPIER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$COPIER_DIR")"
TEMPLATE_SRC="$COPIER_DIR/generated_template"
TMP_DIR="$ROOT_DIR/tmp"

# Configuration for the test run
TEST_PROJECT_NAME="Local Test Enhancer"
TEST_PROJECT_SLUG="test-enhancer"

echo "--- 🔄 Step 1: Rebuilding the Copier Template ---"
bash "$COPIER_DIR/generate-template.sh"

echo "--- 📁 Step 2: Creating Temporary Local Sandbox ---"
# Ensure we start with a completely fresh directory
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
echo "Created local sandbox at: $TMP_DIR"

echo "--- 🏗️ Step 3: Rendering Template with Copier ---"
copier copy "$TEMPLATE_SRC" "$TMP_DIR" \
    -d project_name="$TEST_PROJECT_NAME" \
    -d project_slug="$TEST_PROJECT_SLUG" \
    --defaults \
    --trust

echo "--- 🚀 Step 4: Executing Generated Helm Script ---"
cd "$TMP_DIR"

# Ensure all scripts in the generated hack folder are executable
chmod +x ./hack/*.sh

MAIN_SCRIPT="./hack/run-helm-with-local-build.sh"

if [ -f "$MAIN_SCRIPT" ]; then
    echo "Running $MAIN_SCRIPT inside generated project..."
    bash "$MAIN_SCRIPT"
else
    echo "⚠️ ERROR: Could not find $MAIN_SCRIPT in the generated project."
    exit 1
fi

echo "--- ✅ Template Sandbox Deployment Complete! ---"
echo "Your test environment is running inside the cluster."
echo "The final generated project can be viewed and inspected here: $TMP_DIR"