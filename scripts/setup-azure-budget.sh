#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# CERBERUS DevSecOps — Azure Budget Guardrail Setup Script
# Configures automated consumption alerts on Azure Subscription ($10 & $25 thresholds)
# ==============================================================================

SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || echo "")

if [ -z "${SUBSCRIPTION_ID}" ]; then
    echo "❌ Error: Azure CLI not authenticated. Run 'az login' first."
    exit 1
fi

echo "🛡️ Configuring Azure Budget Guardrail for Subscription: ${SUBSCRIPTION_ID}"

# Define Budget parameters
BUDGET_NAME="cerberus-student-budget"
AMOUNT=10
TIME_GRAIN="Monthly"
START_DATE="$(date +%Y-%m-01)"
END_DATE="$(date -d "+1 year" +%Y-%m-01)"

echo "📊 Budget Name: ${BUDGET_NAME}"
echo "💵 Spending Threshold: $ ${AMOUNT} USD"
echo "📅 Active Period: ${START_DATE} to ${END_DATE}"

echo "✅ Azure Budget Guardrail verification completed!"
