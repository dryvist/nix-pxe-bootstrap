# nix-pxe-bootstrap — AI Agent Instructions

@github:JacobPEvans/ai-assistant-instructions

## Repo-specific notes

- **Status: skeleton only.** Module bodies are intentionally `mkEnableOption`
  stubs — do not fill them in unless the implementation epic in the dryvist
  Project explicitly asks for it.
- **Target hardware is unbound.** `hosts/pxe-host/disko.nix`,
  `hosts/pxe-host/networking.nix`, and `hardware-configuration.nix.example`
  carry placeholders. Real `by-id` disk paths and static IPs land in a later
  PR after the device exists.
- **First boot uses `nixos-anywhere`** from an operator Mac to materialize
  `hardware-configuration.nix`. Do not check that file in until after the
  initial bootstrap.
- **Answer files in `answer-files/proxmox-{b,c,d}.toml`** use placeholder
  hashes / NICs / hostnames. Real values come from the dryvist secrets store
  (SOPS-encrypted) and never get committed in plaintext.
- **No custom shell scripts.** Declarative NixOS modules only. If a problem
  feels like it needs a script, restate it as a NixOS module option.
- **Answer-file format:** Proxmox auto-installer TOML. ADR-0003 documents
  why TOML over JSON or YAML.
- **CI:** mirrors the nix-darwin pattern — `alejandra`, `statix`, `deadnix`,
  `nix flake check`, plus mermaid render-diff gate.

## Related repos

See `README.md` ecosystem table.

## Bring-up workflow (operator)

1. Acquire hardware (Pi 4/5 or N100/N305 mini-PC).
2. Fill `hosts/pxe-host/{disko,networking}.nix` with real values via PR.
3. Boot the device into a NixOS installer or any Linux live env with SSH.
4. From operator Mac:
   `nix run github:nix-community/nixos-anywhere -- --flake .#pxe-host root@<ip>`
5. Commit the generated `hardware-configuration.nix` (drop `.example` suffix).
6. Subsequent updates: `nixos-rebuild switch --flake .#pxe-host --target-host root@<ip>`.
