#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# CERBERUS Security Guardrail: Cloud Destruction Script
# ==============================================================================
# Purpose: Instantly destroy all Azure resources to preserve Student Credits ($100)
# Usage: ./scripts/destroy-cloud.sh
# ==============================================================================

echo "⚠️ [CERBERUS] Initiating Azure Infrastructure Destruction..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="${SCRIPT_DIR}/.."

if [ -d "${PROJECT_ROOT}/terraform" ]; then
    cd "${PROJECT_ROOT}/terraform"
    if [ -f "terraform.tfstate" ]; then
        echo "🗑️ Running 'terraform destroy' on Azure AKS & ACR..."
        terraform destroy -auto-approve
        echo "✅ All Azure resources successfully destroyed! Credits preserved."
    else
        echo "ℹ️ No terraform.tfstate found. No active Azure resources to destroy."
    fi
else
    echo "❌ Error: terraform directory not found at ${PROJECT_ROOT}/terraform"
    exit 1
fi
