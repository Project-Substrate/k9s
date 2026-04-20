# CLAUDE.md — Project-Substrate/k9s

Magnon fork of k9s — terminal UI for Kubernetes cluster management. Used by Substrate engineers to navigate and manage Substrate clusters.

## Upstream

`upstream` → `https://github.com/derailed/k9s.git`

Pull upstream changes: `git fetch upstream && git merge upstream/master`

## Magnon Customisations

- Custom skin / theme for Magnon branding
- Pre-configured aliases and shortcuts for Substrate cluster namespaces
- Packaged via Flox environment (`magnon/substrate`)

## Key Commands

```bash
# Build
go build -o k9s cmd/k9s/main.go

# Run against current kubeconfig
./k9s
```

## Key Invariants

- Keep Magnon patches minimal (skin config and alias files only). Do not patch core k9s logic.
- Pull upstream releases regularly — k9s tracks k8s API changes closely.
