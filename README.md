# go-api — DevOps / SRE Portfolio

The Go API is the workload. The subject is everything around it: secure CI/CD on GCP, with GitOps and observability in progress.

Blogs: [LouStackBase](https://loustack.dev/?lang=english)

## Architecture

![Architecture Diagram](docs/architecture.png)

> Solid lines = implemented. Dashed borders = planned (Phase 6–7).

## Key Design Decisions

**WIF over Service Account key**
SA keys are the leading CI/CD credential leak vector. WIF issues short-lived OIDC tokens scoped to a specific GitHub repo — no rotation, no disk storage, expires in minutes.
→ [`main.tf:55`](terraform/bootstrap/main.tf#L55) `attribute_condition` + [`main.tf:67`](terraform/bootstrap/main.tf#L67) `principalSet` member

**Terraform bootstrap layer**
WIF pool, Artifact Registry, and IAM bindings are one-time shared resources. Separating them from environment resources (VPC, GKE) limits blast radius on either side.
→ [`terraform/bootstrap/`](terraform/bootstrap/)

**Least privilege CI Service Account**
`roles/artifactregistry.writer` only. A compromised pipeline can push images; it cannot touch any other GCP resource.
→ [`terraform/bootstrap/main.tf#L72`](terraform/bootstrap/main.tf#L72)

**ArgoCD pull-based GitOps over `kubectl apply` in CI** *(planned — Phase 6)*
Push-based CD requires CI to hold cluster credentials. The plan: ArgoCD syncs from inside the cluster — CI never touches K8s, drift is auto-detected, git is the source of truth.

## Progress

| Phase | Topic | Core SD Concept | Status |
|---|---|---|---|
| 1 | Docker + Kubernetes Core | — | ✅ Done |
| 2 | K8s Failure Modeling | — | ✅ Done |
| 3 | K8s Review Checkpoint | — | ✅ Done |
| 4 | Networking + GCP Fundamentals | Scalability | ✅ Done |
| 5 | IaC + Least Privilege (Terraform + Ansible) | CAP Theorem | ✅ Done |
| 6 | CI/CD + GitOps (GitHub Actions + ArgoCD) | Reliable Delivery | 🔄 In Progress |
| 7 | Monitoring + Observability (GKE + Prometheus + Grafana) | Observability | ⏳ Planned |
| 8 | Advanced SD + Interview Prep | Overload Protection | ⏳ Planned |
| 9 | Best Practices Case Studies | — | ⏳ Planned |

## Phase Highlights

### Phase 1 — Docker + Kubernetes Core
- Linux namespace + cgroup; multi-stage Docker build to `scratch` and `distroless`
- Image layer cache optimisation; container restart vs rebuild
- K8s architecture: Control Plane vs Worker Node, reconciliation loop
- Deployment → ReplicaSet → Pod, rolling update (`maxSurge` / `maxUnavailable`)
- Service DNS-based discovery, HPA with metrics-server
- `kubectl` debug flow: `get pods → describe → logs → events`

### Phase 2 — K8s Failure Modeling
- OOMKilled (exit code 137), CrashLoopBackOff exponential backoff, ImagePullBackOff
- Readiness probe vs Liveness probe failure — different recovery behaviour
- ResourceQuota enforcement at the API server layer
- ConfigMap vs Secret: `envFrom` (whole map) vs `valueFrom` (single key)
- Cross-namespace DNS: `service.namespace.svc.cluster.local`

### Phase 3 — K8s Review Checkpoint
Oral review of Phase 1–2 — explain without notes.
- Container vs VM: namespace + cgroup vs hypervisor
- Pod / Deployment / ReplicaSet; Service label selector mechanism
- OOMKilled, CrashLoopBackOff, Pod Pending — root causes and debug approach
- requests vs limits: Scheduler uses requests, runtime enforces limits
- Readiness vs Liveness probe failure — different consequences
- ConfigMap vs Secret; cross-namespace DNS

### Phase 4 — Networking + GCP Fundamentals
- DNS resolution, TLS handshake, HTTP statelessness
- L4 vs L7 load balancer trade-offs; reverse proxy pattern
- GCP VPC (global) vs Azure VNet (regional); Service Account vs Managed Identity
- GCP hands-on: VPC, Subnet, Firewall Rules, Service Account

> System Design: Networking Essentials, Client-Server Architecture, Load Balancer, API Gateway

### Phase 5 — IaC + Least Privilege
- Terraform modules, multi-environment structure, GCS remote state + state locking
- `terraform state mv / rm / import` for safe refactoring
- Workload Identity Federation: GitHub Actions → GCP OIDC, no SA key
- Ansible: inventory, playbook, idempotency (`file` / `copy` vs `command` module)

> System Design: CAP Theorem, Scalability, Overload Protection, Scaling Reads, Scaling Writes

### Phase 6 — CI/CD + GitOps *(in progress)*
- GitHub Actions: `test → build → push`, job-level `needs` gates
- WIF keyless auth, `id-token: write` scoped to deploy job only
- Docker image push to Artifact Registry on every merge to main
- Terraform bootstrap layer: one-time GCP setup separated from environments
- ArgoCD on k3s: pull-based GitOps *(in progress)*

> System Design: Reliable Delivery, API Design, Queue, Kafka, Long Running Tasks, Container optimisation


## Repository Structure

```
.
├── cmd/server/          # entrypoint
├── internal/
│   └── handler/         # HTTP handlers (health, crash, oom)
├── k8s/
│   ├── deployment.yaml  # rolling update, resource limits
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── hpa.yaml
├── terraform/
│   ├── bootstrap/       # one-time GCP setup: WIF, Artifact Registry, SA, IAM
│   ├── environments/dev/
│   └── modules/         # reusable modules (vpc)
├── .github/workflows/
│   └── ci.yml           # test → build → push image to AR
├── Dockerfile           # multi-stage, scratch base
└── Dockerfile.distroless
```

## Tech Stack

| Layer | Tech |
|---|---|
| Language | Go |
| Container | Docker (multi-stage, scratch base) |
| Registry | GCP Artifact Registry |
| IaC | Terraform / OpenTofu |
| CI/CD | GitHub Actions |
| Auth | Workload Identity Federation (OIDC, keyless) |
| Orchestration | Kubernetes (k3s local, GKE planned) |
| Cloud | GCP |
| Planned | ArgoCD, Prometheus, Grafana |
