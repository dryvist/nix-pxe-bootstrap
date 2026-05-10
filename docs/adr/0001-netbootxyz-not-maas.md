# ADR-0001: netboot.xyz on NixOS, not MAAS or Foreman

- Status: Accepted
- Date: 2026-05-10

## Context

The dryvist cluster (B+C+D) needs unattended bare-metal install. Three
candidates were considered:

1. **netboot.xyz** on a small NixOS host — single-purpose iPXE menu.
2. **Canonical MAAS** — full IPAM + DHCP + commissioning + lifecycle.
3. **Foreman / Katello** — full provisioning + config-mgmt host.

## Decision

Use **netboot.xyz on NixOS** (this repo).

## Rationale

- Scope: PXE is a one-time-per-node activity. We need a boot menu and an
  HTTP host for ISOs + answer files — not a full lifecycle / inventory tool.
  Tofu + Ansible already own VM/LXC lifecycle and inventory.
- Operational surface: a Pi or N100 mini-PC running NixOS is a single
  declarative file we can rebuild from scratch in minutes. MAAS / Foreman
  are heavyweight services with their own DBs, upgrades, and failure modes.
- DHCP authority stays on the UDW gateway. We only set `next-server` to the
  pxe-host; we are not replacing the LAN DHCP server.
- NixOS gives us reproducible config, sops-encrypted secrets, and a clean
  reset path — the same primitives we use for the AI host (server A).

## Consequences

- We do NOT get commissioning / hardware enrollment workflows. That's fine;
  the cluster is 3 fixed nodes plus rare reformat events.
- Adding a 4th node = 1 PR in this repo (new answer file + DHCP
  reservation) + 1 PR in `ansible-proxmox-cluster` + 1 PR in
  `tofu-proxmox-cluster`. No MAAS UI dance.
- If we ever outgrow this (10+ heterogeneous nodes), revisit MAAS.
