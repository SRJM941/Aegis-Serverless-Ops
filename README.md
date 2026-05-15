# Serverless Enterprise REST API Platform (IaC)

![Security Scan](https://img.shields.io/badge/security-tfsec%20passed-brightgreen?style=for-the-badge&logo=terraform)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge&logo=github-actions)

A production-grade, serverless architecture built on AWS using Terraform. This project demonstrates a robust CI/CD pipeline, hardened security through IaC scanning, and scalable cloud-native principles.

## 🏗️ Architecture Overview
This platform utilizes a completely serverless stack to ensure high availability, zero maintenance, and automatic scaling.

- **Frontend/Ingress:** Amazon API Gateway (REST) with integrated WAF capabilities.
- **Compute:** AWS Lambda (Python 3.9) for scalable, event-driven execution.
- **Data Layer:** Amazon DynamoDB (On-Demand) with Point-in-Time Recovery (PITR) enabled.
- **Networking:** Custom VPC with public/private subnets and VPC Flow Logs for network observability.
- **Logging:** Centralized CloudWatch Logs with automated retention policies.

## 🚀 Key Features & Design Principles
- **Hardened Security:** Zero-trust approach using OIDC (OpenID Connect) for GitHub Actions to AWS communication—no hardcoded long-lived credentials.
- **Shift-Left Security:** Automated security scanning using `tfsec` and `tflint` within the CI/CD pipeline to catch vulnerabilities before deployment.
- **State Management:** Enterprise-grade remote state locking using S3 and DynamoDB to prevent concurrent pipeline conflicts.
- **GitOps Workflow:** Fully automated CI/CD lifecycle using GitHub Actions:
    - `Plan` Stage: Triggered on Pull Request for validation, linting, and security audit.
    - `Apply` Stage: Triggered on merge to `main` branch for production deployment.
- **Modular Design:** Infrastructure decomposed into `networking`, `security`, and `compute` modules for scalability and maintainability.

## 🛠️ Tech Stack
- **Infrastructure:** Terraform (v1.6+)
- **Cloud Provider:** AWS (Region: `ap-south-1`)
- **CI/CD:** GitHub Actions
- **Security/Linting:** `tfsec`, `tflint`

## 📋 CI/CD Pipeline Flow
1. **Linting & Security:** Automatic code validation via `tflint` and `tfsec`.
2. **Infrastructure Planning:** Dry-run via `terraform plan` to audit changes.
3. **State Locking:** DynamoDB-backed locking ensures atomic operations during deployments.
4. **Automated Deployment:** CI/CD triggers `terraform apply` only upon successful merge to `main`.

## 📂 Project Structure
```text
.
├── .github/workflows/      # CI/CD pipelines (Plan & Apply)
├── terraform/
│   ├── modules/
│   │   ├── compute/        # Lambda, API Gateway, DynamoDB
│   │   ├── networking/     # VPC, Subnets, Flow Logs
│   │   └── security/       # IAM Roles, Policies
│   └── backend.tf          # Remote state configuration
└── README.md
