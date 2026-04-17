# go-api

A minimal Go HTTP API used as a vehicle for practising production-grade DevOps and infrastructure patterns on GCP.

The application itself is intentionally simple. The focus is on the infrastructure around it: keyless CI/CD with Workload Identity Federation, Terraform-managed GCP resources, and Kubernetes deployment patterns.

## What This Covers

- **Keyless GCP auth from GitHub Actions** — Workload Identity Federation (OIDC), no Service Account key stored anywhere
- **Terraform bootstrap layer** — one-time GCP setup (WIF pool, Artifact Registry, IAM) separated from environment resources
- **Least privilege IAM** — CI Service Account holds only `roles/artifactregistry.writer`
- **CI/CD pipeline** — test → build → deploy, Docker image pushed to GCP Artifact Registry on every merge to main
- **Kubernetes manifests** — Deployment with rolling update strategy, resource limits, HPA, ConfigMap, Secret, Service

## Architecture

```
GitHub Actions (push to main)
  |
  | OIDC token (short-lived, no key)
  v
GCP Workload Identity Federation
  -> validates issuer + repository claim
  -> impersonates Service Account (artifactregistry.writer only)
  |
  v
Build Docker image -> push to Artifact Registry
```

## Repository Structure

```
.
├── cmd/server/         # application entrypoint
├── internal/           # business logic
├── server/             # HTTP handlers
├── k8s/                # Kubernetes manifests
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── hpa.yaml
├── terraform/
│   ├── bootstrap/      # one-time GCP setup (WIF, Artifact Registry, SA, IAM)
│   ├── environments/   # environment-specific resources
│   └── modules/        # reusable modules (vpc)
├── .github/workflows/
│   └── ci.yml          # CI pipeline
├── Dockerfile          # multi-stage build to scratch
└── Dockerfile.distroless
```

## CI Pipeline

```
on: push to main / pull_request to main

test  ->  build  ->  deploy
                      |
                      |- google-github-actions/auth (WIF, no SA key)
                      |- docker build
                      └- docker push  →  GCP Artifact Registry
```

The `deploy` job requires `id-token: write` permission for WIF OIDC token acquisition. The permission is scoped to the deploy job only, not the workflow.

## Terraform Bootstrap

The bootstrap layer provisions GCP resources that are created once and shared across environments:

- `google_iam_workload_identity_pool` + `google_iam_workload_identity_pool_provider` — WIF trust relationship with GitHub
- `google_artifact_registry_repository` — Docker image registry
- `google_service_account` — CI identity with least privilege
- `google_service_account_iam_member` — allows WIF principal to impersonate SA
- `google_project_iam_member` — grants SA the `artifactregistry.writer` role
- `google_project_service` — enables required GCP APIs

State is stored in GCS with prefix isolation:

```hcl
backend "gcs" {
  bucket = "<project-id>-tfstate"
  prefix = "bootstrap"
}
```

## Prerequisites

- GCP project with billing enabled
- GCS bucket for Terraform state (created manually before first `tofu apply`)
- GitHub repository variables set:
  - `GCP_PROJECT_ID`
  - `GCP_WORKLOAD_IDENTITY_PROVIDER` (from bootstrap output)
  - `GCP_SERVICE_ACCOUNT` (from bootstrap output)

## Tech Stack

| Layer | Tech |
|---|---|
| Language | Go |
| Container | Docker (multi-stage, scratch base) |
| Registry | GCP Artifact Registry |
| IaC | Terraform / OpenTofu |
| CI/CD | GitHub Actions |
| Auth | Workload Identity Federation (OIDC) |
| Orchestration | Kubernetes |
| Cloud | GCP |
