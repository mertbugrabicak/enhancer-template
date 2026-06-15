#!/usr/bin/env bash

set -e

# ==========================================
# Dynamic Directory Resolution
# ==========================================
COPIER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$COPIER_DIR")"
TMP_DIR="$ROOT_DIR/tmp"

echo "--- 🔍 Checking for Existing Sandbox Directory ---"
if [ ! -d "$TMP_DIR" ]; then
    echo "❌ Error: No active sandbox folder found at: $TMP_DIR"
    echo "You must run the full template generation script at least once first:"
    echo "  ./copier/run-local-helm-from-template.sh"
    exit 1
fi

echo "--- 🚀 Redeploying Helm Chart directly from Sandbox ---"
echo "Target Workspace: $TMP_DIR"

# Move straight into the existing sandbox tree
cd "$TMP_DIR"

# Ensure script permissions are correct inside the sandbox
chmod +x ./hack/*.sh

# Run the generated deployment workflow
MAIN_SCRIPT="./hack/run-helm-with-local-build.sh"

if [ -f "$MAIN_SCRIPT" ]; then
    echo "Running internal sandbox build and update loop..."
    bash "$MAIN_SCRIPT"
else
    echo "❌ Error: Could not find $MAIN_SCRIPT inside the sandbox."
    exit 1
fi

echo "--- ✅ Deployment Complete! ---"
echo "Your updates have been applied to the active cluster."
echo "Sandbox remains preserved at: $TMP_DIR"