# k9s

## Stack
Go

## Quick Start
```bash
# Install dependencies
go mod download

# Run development server
go run ./cmd/...
```

## Testing
```bash
make test
```

## Key Files
- `main.go` — k9s terminal UI entrypoint; customized for Substrate cluster access (ash + hel1)
- `k8s/base/` — Kubernetes manifests
- `.github/workflows/` — CI/CD pipelines
