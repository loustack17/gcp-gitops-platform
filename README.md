# go-api — AI Platform Portfolio

## Proof

Built
- Go service
- Multi-stage Docker build
- GCP Artifact Registry
- Workload Identity Federation
- GitHub Actions CI/CD
- ArgoCD pull-based GitOps
- Terraform bootstrap split

Why it matters
- WIF over static service-account key
- GitOps over `kubectl apply` from CI
- Least-privilege CI access
- Traceable image tags: `{env}-{sha}`

Refs
- `terraform/bootstrap/main.tf`
- `k8s/argocd/application.yaml`
- `.github/workflows/ci.yml`
- `Dockerfile`

## Next
- Observability
- Agent loop
- Memory + guardrails
- Orchestration + hooks
- RAG over ops docs
- Model gateway
- AI Platform portfolio system

## Progress

| Phase | Topic | Status |
|---|---|---|
| 1 | Docker + Kubernetes Core | Done |
| 2 | K8s Failure Modeling | Done |
| 3 | K8s Review Checkpoint | Done |
| 4 | Networking + GCP Fundamentals | Done |
| 5 | IaC + Least Privilege | Done |
| 6 | CI/CD + GitOps | Done |
| 7 | Monitoring + Observability | Planned |
| 8 | Advanced SD + Interview Prep | Planned |
| 9 | Best Practices Case Studies | Planned |
| 10 | Agent Core Loop | Planned |
| 11 | Memory + Guardrails | Planned |
| 12 | Workflow Orchestration + Hooks | Planned |
| 13 | RAG + Ops Knowledge | Planned |
| 14 | Model Serving + Provider Gateway | Planned |
| 15 | AI Platform — Portfolio Project | Planned |
