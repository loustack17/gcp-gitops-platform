# go-api — DevOps / SRE / Agent Platform Portfolio

Go API is workload. Portfolio signal is infra around it: GCP, CI/CD, GitOps, Kubernetes, observability, future agent-platform track.

Blog: [LouStackBase](https://loustack.dev/?lang=english)

## What this repo proves

Implemented now:
- Go service containerized with multi-stage Docker build
- GCP Artifact Registry + Workload Identity Federation
- GitHub Actions CI/CD
- ArgoCD pull-based GitOps on k3s
- Terraform bootstrap split for shared GCP resources

Planned next:
- Prometheus + Grafana observability
- Agent runtime, memory, guardrails, hooks
- RAG over ops runbooks
- model serving / provider gateway

## Key signals

- WIF over Service Account key
  - short-lived OIDC, no static key in CI
  - refs: `terraform/bootstrap/main.tf`

- ArgoCD pull-based GitOps over `kubectl apply` in CI
  - CI does not hold cluster creds
  - git is source of truth
  - refs: `k8s/argocd/application.yaml`

- Least-privilege CI service account
  - image push only, not broad GCP access
  - refs: `terraform/bootstrap/main.tf`

- Terraform bootstrap separation
  - shared foundation split from env resources
  - refs: `terraform/bootstrap/`

- Image tags use `{env}-{sha}`
  - deploy traceability by env + commit

## Progress

| Phase | Topic | SD Concept | Status |
|---|---|---|---|
| 1 | Docker + Kubernetes Core | — | Done |
| 2 | K8s Failure Modeling | — | Done |
| 3 | K8s Review Checkpoint | — | Done |
| 4 | Networking + GCP Fundamentals | Scalability | Done |
| 5 | IaC + Least Privilege | CAP Theorem | Done |
| 6 | CI/CD + GitOps | Reliable Delivery | Done |
| 7 | Monitoring + Observability | Observability | Planned |
| 8 | Advanced SD + Interview Prep | Overload Protection | Planned |
| 9 | Best Practices Case Studies | — | Planned |
| 10 | Agent Core Loop | Tool Use Loop | Planned |
| 11 | Memory + Guardrails | State + Safety | Planned |
| 12 | Workflow Orchestration + Hooks | Stateful Orchestration | Planned |
| 13 | RAG + Ops Knowledge | Retrieval Systems | Planned |
| 14 | Model Serving + Provider Gateway | Serving Boundary | Planned |
| 15 | DevOps Agent Platform — Portfolio Project | Full System Integration | Planned |

## Repo structure

```text
.
├── cmd/server/
├── internal/handler/
├── k8s/
│   ├── base/
│   ├── argocd/
│   └── test/
├── terraform/
│   ├── bootstrap/
│   ├── environments/dev/
│   └── modules/
├── .github/workflows/ci.yml
├── Dockerfile
└── Dockerfile.distroless
```

## Target direction

Main track:
- Harness / Agent Platform Engineer

Support track:
- Applied AI infra: RAG, model serving, provider abstraction
