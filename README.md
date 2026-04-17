# go-api — DevOps Learning Portfolio

A structured, self-directed learning portfolio covering the full DevOps/SRE stack on GCP.
The Go API is intentionally minimal — it exists as a concrete target to practice real infrastructure and deployment patterns around.

## Learning Approach

> See the result first → understand why → connect to system design trade-offs

Each phase is hands-on before theory. The goal is not to memorise tooling, but to understand *why* each design decision exists and what the trade-offs are.

Blogs documenting each phase: [LouStackBase](https://loustack.dev/?lang=english)

---

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

---

## Architecture

![Architecture](docs/architecture.png)

> Solid lines = implemented. Dashed borders + dashed lines = planned (Phase 6–7).

---

## Phase Highlights

### Phase 1 — Docker + Kubernetes Core
- Linux namespace + cgroup; multi-stage Docker build to `scratch` and `distroless`
- Image layer cache, container restart vs rebuild, cgroup resource limits
- K8s architecture: Control Plane vs Worker Node, reconciliation loop
- Deployment → ReplicaSet → Pod, rolling update (`maxSurge` / `maxUnavailable`)
- Service DNS-based discovery, HPA with metrics-server
- `kubectl` debug flow: `get pods → describe → logs → events`

### Phase 2 — K8s Failure Modeling
- OOMKilled (exit code 137), CrashLoopBackOff exponential backoff, ImagePullBackOff
- Readiness probe vs Liveness probe failure — different outcomes
- ResourceQuota enforcement at the API server layer
- ConfigMap vs Secret: `envFrom` (whole map) vs `valueFrom` (single key)
- Cross-namespace DNS: `service.namespace.svc.cluster.local`

### Phase 4 — Networking + GCP Fundamentals
- DNS resolution flow, TLS handshake, HTTP statelessness
- L4 vs L7 load balancer trade-offs; reverse proxy pattern
- GCP VPC (global) vs Azure VNet (regional); Service Account vs Managed Identity
- GCP hands-on: VPC, Subnet, Firewall Rules, Service Account
- SD: Networking Essentials, Client-Server Architecture, Load Balancer, API Gateway

### Phase 5 — IaC + Least Privilege
- Terraform modules, multi-environment structure, GCS remote state + locking
- `terraform state mv / rm / import` for refactoring
- Workload Identity Federation: GitHub Actions → GCP OIDC, no SA key
- Ansible: inventory, playbook, idempotency (`file` / `copy` vs `command` module)
- SD: CAP Theorem, Scalability, Overload Protection, Scaling Reads, Scaling Writes

### Phase 6 — CI/CD + GitOps *(in progress)*
- GitHub Actions: `test → build → deploy`, job-level `needs` gates
- WIF keyless auth, `id-token: write` scoped to deploy job only
- Docker image push to Artifact Registry on every merge to main
- Terraform bootstrap layer: one-time GCP setup separated from environments
- ArgoCD on k3s: pull-based GitOps, push-based vs pull-based trade-offs *(in progress)*
- SD: Reliable Delivery, API Design, Queue, Kafka, Long Running Tasks, Container optimisation

### Phase 7 — Monitoring + Observability *(planned)*
- GKE Autopilot cluster; deploy go-api with Artifact Registry image
- Prometheus + Grafana: QPS, error rate, P50/P95/P99 latency dashboard
- go-api `/metrics` endpoint: Counter, Gauge, Histogram
- Alert design: symptom-based alerting (error rate > 1%, P95 latency > 500ms)
- SD: Observability (four golden signals), Caching, Redis, Distributed Cache, Database Transactions, Replication, CDN, Data Pipeline, Dealing with Contention

### Phase 8 — Advanced SD + Interview Prep *(planned)*
- Rate limiting middleware on go-api (token bucket)
- Interview prep: K8s failure scenarios, Terraform state, CI/CD trade-offs, GCP architecture
- SD: Consistent Hashing, Sharding, Database Indexing, PostgreSQL, DynamoDB, OLTP vs OLAP, Distributed Lock, Zookeeper, GraphQL, gRPC, Real-time Updates, Large Blobs, Search System

### Phase 9 — Best Practices Case Studies *(planned)*
End-to-end system design practice: requirements → capacity estimation → API design → architecture → trade-offs.
- YouTube, Messenger, Spotify Trending, Airbnb Booking, Earthquake Notification System
- Webhook Platform, Google Docs, LLM Inference API, Q&A Support Agent

---

## Repository Structure

```
.
├── cmd/server/         # application entrypoint
├── internal/           # business logic
├── server/             # HTTP handlers
├── k8s/                # Kubernetes manifests
│   ├── deployment.yaml # rolling update, resource limits
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   └── hpa.yaml
├── terraform/
│   ├── bootstrap/      # one-time GCP setup: WIF, Artifact Registry, SA, IAM
│   ├── environments/   # environment-specific resources
│   └── modules/        # reusable modules (vpc)
├── .github/workflows/
│   └── ci.yml          # CI: test → build → deploy
├── Dockerfile          # multi-stage build to scratch
└── Dockerfile.distroless
```

---

## Tech Stack

| Layer | Tech |
|---|---|
| Language | Go |
| Container | Docker (multi-stage, scratch base) |
| Registry | GCP Artifact Registry |
| IaC | Terraform / OpenTofu |
| CI/CD | GitHub Actions |
| Auth | Workload Identity Federation (OIDC, keyless) |
| Orchestration | Kubernetes (k3s locally, GKE planned) |
| Cloud | GCP |
| Planned | ArgoCD, Prometheus, Grafana |
