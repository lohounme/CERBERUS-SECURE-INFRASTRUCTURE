# 🐲 PROJECT CERBERUS — Secure Infrastructure & Multi-Layer Defense

[![CERBERUS DevSecOps Pipeline](https://github.com/lohounme/CERBERUS-SECURE-INFRASTRUCTURE/actions/workflows/cerberus-pipeline.yml/badge.svg)](https://github.com/lohounme/CERBERUS-SECURE-INFRASTRUCTURE/actions/workflows/cerberus-pipeline.yml)
![Azure](https://img.shields.io/badge/Azure-AKS-0089D6?logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-v4-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Kyverno-326CE5?logo=kubernetes&logoColor=white)
![Supply Chain](https://img.shields.io/badge/Supply_Chain-Syft_|_Cosign-green?logo=sigstore&logoColor=white)
![DAST](https://img.shields.io/badge/DAST-OWASP_100%25-brightgreen?logo=owasp&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue)

> **Enterprise Multi-Layer DevSecOps Defense System**: Infrastructure as Code (Terraform azurerm v4), Kubernetes Admission Policy Engine (Kyverno), Supply Chain Security (Syft SBOM + Cosign Attestation), Dynamic Security Testing (DAST OWASP), and STRIDE Threat Modeling.

---

## 📐 Architecture Overview

```text
               ┌─────────────────────────────────────────────────────────┐
               │         CERBERUS DevSecOps CI/CD Pipeline               │
               └────────────────────────────┬────────────────────────────┘
                                            │
        ┌───────────────────────────────────┼───────────────────────────────────┐
        │                                   │                                   │
        ▼                                   ▼                                   ▼
┌───────────────┐                  ┌─────────────────┐                 ┌─────────────────┐
│ 1. IaC Scan   │                  │ 2. Build & SBOM │                 │ 3. Policy Gate  │
│ Checkov Audit │                  │ Syft + Cosign   │                 │ Kyverno Enforce │
└───────┬───────┘                  └────────┬────────┘                 └────────┬────────┘
        │                                   │                                   │
        └───────────────────────────────────┼───────────────────────────────────┘
                                            │
                                            ▼
                        ┌───────────────────────────────────────┐
                        │ 4. Kubernetes Runtime & DAST Scan     │
                        │ Hardened Non-Root API (Port 3000)     │
                        └───────────────────────────────────────┘
```

---

## 🛠️ Security Layers & Key Features

### 1. Infrastructure as Code (IaC) & Azure AKS
- **Terraform Stack** : Provisioning of Azure Resource Group (`rg-cerberus-devsecops`), Azure Container Registry (`acrcerberusdevsecops`), and Azure Kubernetes Service (`aks-cerberus-cluster`).
- **Provider Upgrade** : Compatible with `azurerm ~> 4.0`.
- **Static Security Audit** : `checkov` scanning configured with zero critical bypasses.

### 2. Kubernetes Container Hardening & Policy Engine
- **Non-Root Execution** : Pod & Container security contexts configured with `runAsNonRoot: true`, `runAsUser: 10001`, `runAsGroup: 10001`.
- **CIS Benchmark Hardening** : `readOnlyRootFilesystem: true`, `capabilities.drop: ["ALL"]`, and resource limits (`requests: 64Mi/100m`, `limits: 128Mi/250m`).
- **Kyverno Policy-as-Code** : Admission policy `disallow-root-user` active in `Enforce` mode. Blocks any attempt to launch UID 0 containers with a custom security violation error.

### 3. Supply Chain Security (Syft & Cosign)
- **Software Bill of Materials (SBOM)** : Automated SPDX JSON inventory generated via `syft` (`docs/sbom.spdx.json`).
- **Cryptographic Attestation** : Keypair generated and signed via `cosign`. Artifact attestation verified with **`Verified OK`**.

### 4. Dynamic Application Security Testing (DAST)
- **OWASP Top 10 Audit** : Live runtime security audit on `http://localhost:8080`.
- **Score** : **`100% Compliance (9/9 Passed)`**. Enforced Helmet security headers, hidden `X-Powered-By` server fingerprints, and stack-leak-free 404 error handling.

### 5. Threat Modeling (STRIDE)
- Full architectural threat analysis matrix documented in [`threat-model/THREAT_MODEL.md`](file:///home/andochelohounme/CERBERUS-SECURE-INFRASTRUCTURE/threat-model/THREAT_MODEL.md).

---

## 🚀 Quickstart & Local Reproduction

### Prerequisites
- `docker`, `kind`, `kubectl`, `terraform`, `syft`, `cosign`, `python3`

### 1. Run Microservice API Locally in Kind
```bash
# Build hardened Docker image
docker build --pull=false -t cerberus-api:v1.0.0 .

# Load image into Kind cluster
kind load docker-image cerberus-api:v1.0.0 --name cerberus-cluster

# Deploy to Kubernetes
kubectl apply -f k8s/deployement.yaml
```

### 2. Verify Kyverno Root-User Blocking Policy
```bash
# Apply Kyverno policy
kubectl apply -f k8s/policies/disallow-root-user.yaml

# Test unauthorized root container (Should be BLOCKED)
kubectl run test-root-pod --image=nginx --restart=Never --overrides='{"spec": {"containers": [{"name": "nginx", "image": "nginx", "securityContext": {"runAsUser": 0}}]}}'
```

### 3. Generate SBOM & Verify Cosign Signature
```bash
# Generate SBOM
syft cerberus-api:v1.0.0 -o spdx-json > docs/sbom.spdx.json

# Verify signature bundle
cosign verify-blob --key cosign.pub --bundle docs/sbom.spdx.json.bundle docs/sbom.spdx.json
```

### 4. Run DAST Security Audit
```bash
# Forward Kubernetes service
kubectl port-forward service/cerberus-api-service 8080:80

# Execute DAST scan (In another terminal)
python3 scripts/dast-scanner.py
```

---

## 📜 License
This project is licensed under the MIT License — see the [LICENSE](file:///home/andochelohounme/CERBERUS-SECURE-INFRASTRUCTURE/LICENSE) file for details.