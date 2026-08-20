# 🐲 PROJECT CERBERUS — Secure Infrastructure & Multi-Layer Defense

[![CERBERUS DevSecOps Pipeline](https://github.com/lohounme/CERBERUS-SECURE-INFRASTRUCTURE/actions/workflows/cerberus-pipeline.yml/badge.svg)](https://github.com/lohounme/CERBERUS-SECURE-INFRASTRUCTURE/actions/workflows/cerberus-pipeline.yml)
![Azure](https://img.shields.io/badge/Azure-AKS-0089D6?logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Kyverno-326CE5?logo=kubernetes&logoColor=white)
![Security](https://img.shields.io/badge/Security-DAST_|_SBOM_|_Sigstore-critical?logo=shield&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue)

> **Multi-layer DevSecOps Pipeline & Infrastructure Security**: Terraform IaC Scanning, Kubernetes Admission Policies, DAST Runtime Testing, and Supply Chain Security (SBOM + Sigstore).

---

## 📌 Project Overview

**CERBERUS** is an enterprise-grade Cloud Infrastructure and DevSecOps Security project. It covers end-to-end multi-layer defense for **NEXUS CORP**:
- **Infrastructure as Code (IaC) Security**: Automated Terraform scanning with Checkov.
- **Cloud Infrastructure**: Azure Kubernetes Service (AKS) & Azure Container Registry (ACR) provisioned via Terraform.
- **Kubernetes Hardening**: Enforced non-root Pod admission policies and network isolation.
- **Supply Chain Security**: Automated Software Bill of Materials (SBOM) with Syft and cryptographic artifact signing with Cosign / Sigstore.
- **Dynamic Application Security Testing (DAST)**: Automated runtime API scanning with OWASP ZAP in staging.
- **Threat Modeling**: Architecture threat analysis based on the STRIDE framework.

---

## 🏗️ Architecture

*(Work in progress: Initializing Step 1)*