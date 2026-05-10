# ADR-0003: Proxmox auto-installer answer files in TOML

- Status: Accepted
- Date: 2026-05-10

## Context

[Proxmox auto-installer](https://pve.proxmox.com/wiki/Automated_Installation)
accepts answer files in TOML, JSON, or YAML.

## Decision

Use **TOML** (`answer-files/proxmox-{b,c,d}.toml`).

## Rationale

- TOML is the format used in the upstream Proxmox documentation examples,
  so copy/paste from official docs works without translation.
- TOML's section-based syntax maps cleanly to the auto-installer's
  `[global]` / `[network]` / `[disk-setup]` structure.
- TOML is friendlier than YAML for this use case — no significant
  whitespace, no anchor/alias surprises.
- JSON works too, but is harder to skim and lacks comments.

## Consequences

- Per-node files live under `answer-files/`, one per cluster node.
- Secrets (root password hashes, operator SSH keys) are SOPS-templated in
  at render time — the committed TOML files contain placeholder values
  only. See ADR-0004 (future) for the SOPS templating mechanism.
- If Proxmox upstream changes the answer-file schema, this is a single
  point of update for all cluster nodes.
