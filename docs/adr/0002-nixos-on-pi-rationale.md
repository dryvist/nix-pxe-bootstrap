# ADR-0002: NixOS on Raspberry Pi (or N100/N305 mini-PC)

- Status: Accepted
- Date: 2026-05-10

## Context

We need a tiny always-on host on the management VLAN to serve PXE. Options:

1. **Raspberry Pi 4/5 + NixOS** — quiet, ~5 W idle, off-the-shelf hardware.
2. **N100/N305 mini-PC + NixOS** — slightly more horsepower, x86_64
   (broader nixpkgs / hardware module coverage), still <15 W idle.
3. **LXC on the cluster** — circular dependency (cluster doesn't exist yet
   when we need PXE), so rejected outright.
4. **Spare desktop running Linux** — too much idle power, too much
   surface area for a tiny role.

## Decision

Build the flake to support **both Pi and N100/N305**, default the
`hosts/pxe-host` example to the Pi 4 hardware module, and let the operator
swap modules when the device is bound.

## Rationale

- Standalone NixOS deploy via `nixos-anywhere` is identical for either
  target — the only diff is the hardware module and the disko layout.
- aarch64-linux is `nixpkgs` first-class; binary cache hits are fine.
- Pi gives us a clean reset story (re-flash an SD card or NVMe HAT).

## Consequences

- `nixos-hardware.nixosModules.raspberry-pi-4` is in the flake by default;
  swap to a different module (or drop entirely for x86_64) when the
  hardware is bound.
- The disko layout is a placeholder until the device exists.
- The flake's default system is `aarch64-linux`. If we choose x86_64, add
  `x86_64-linux` to the supported systems list and update
  `hardware-configuration.nix` accordingly.
