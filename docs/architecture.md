# Architecture

## Layer 1 — Platform substrate
- Go service workload
- Docker image build
- Kubernetes manifests
- GCP Artifact Registry
- GitHub Actions CI/CD
- Workload Identity Federation
- ArgoCD GitOps
- Terraform bootstrap + dev VPC module

## Layer 2 — Observability
Next target:
- `/metrics`
- Prometheus scrape
- Grafana dashboard
- alert rule for 5xx or latency

## Layer 3 — AI operations layer
Next target:
- agent/tool loop
- `query_prometheus`
- `get_pod_logs`
- `list_deployments`
- `get_argocd_status`
- `search_runbooks`

## Layer 4 — Safety layer
Next target:
- guarded `trigger_rollback`
- human confirmation
- audit log
- session state / durable memory later

## Operating story
1. service unhealthy
2. metrics or alert show problem
3. agent inspects metrics, deployment state, logs, runbooks
4. agent explains likely cause
5. agent suggests rollback
6. human approves or rejects
7. system writes audit log

## Honest claim now
- platform substrate implemented
- observability and AI operations layer planned next
