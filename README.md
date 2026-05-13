# AI Platform Portfolio

Production-style platform portfolio built from infra layer up: GCP, Terraform/OpenTofu, Kubernetes, GitHub Actions, Workload Identity Federation, Artifact Registry, and ArgoCD GitOps. Next layer adds observability and AI-assisted incident triage with tool use, runbook retrieval, guarded rollback, and auditability.

## Current positioning
- Built now: platform substrate
- In progress next: observability + AI operations layer
- Honest claim now: AI Platform foundation, not full AI Platform yet

## Built
- Go service
- Multi-stage Docker build
- Kubernetes manifests
- GCP Artifact Registry
- Workload Identity Federation
- GitHub Actions CI/CD
- ArgoCD pull-based GitOps
- Terraform bootstrap
- Terraform dev VPC module
- Kubernetes failure modeling

## Why this matters
- Keyless CI auth via WIF, not static service-account key
- Pull-based GitOps keeps cluster deployment authority out of CI
- Traceable image tags: `{env}-{sha}`
- Terraform foundation split from environment resources to reduce blast radius
- Distroless runtime cuts attack surface

## Truth table

| Layer | Status |
|---|---|
| Go API | Done |
| Docker | Done |
| Kubernetes | Done |
| Terraform bootstrap | Done |
| Terraform dev VPC module | Done |
| GitHub Actions CI/CD | Done |
| Artifact Registry | Done |
| Workload Identity Federation | Done |
| ArgoCD GitOps | Done |
| Failure modeling | Done |
| Prometheus/Grafana | Next |
| Agent tool loop | Planned |
| Runbook retrieval | Planned |
| Model gateway | Planned |
| Guarded rollback | Planned |
| Audit log | Planned |

## Refs
- `terraform/bootstrap/main.tf`
- `terraform/modules/vpc/`
- `terraform/environments/dev/`
- `k8s/argocd/application.yaml`
- `.github/workflows/ci.yml`
- `Dockerfile`
- `docs/architecture.md`
- `docs/interview-one-pager.md`

## Next
- Prometheus + Grafana
- Runbooks in markdown
- First agent tool loop
  - `query_prometheus`
  - `get_pod_logs`
  - `list_deployments`
  - `get_argocd_status`
  - `search_runbooks`
- Guarded rollback + audit log
