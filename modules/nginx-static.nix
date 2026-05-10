# nginx-static — static HTTP host for Proxmox auto-installer ISOs and other
# PXE-time payloads.
#
# Skeleton: only declares the option surface. Implementation lands in the
# `netboot.xyz on Pi: implementation` epic in the dryvist Project.
{ config, lib, ... }:
let
  cfg = config.services.dryvist.pxe.nginxStatic;
in
{
  options.services.dryvist.pxe.nginxStatic = {
    enable = lib.mkEnableOption "nginx static file host for PXE-time payloads";

    # Future option surface (unused while enable = false):
    # isoPath    = lib.mkOption { type = lib.types.path; default = "/srv/pxe/iso"; };
    # listenPort = lib.mkOption { type = lib.types.port; default = 80; };
    # hostName   = lib.mkOption { type = lib.types.str; default = "pxe.example.local"; };
  };

  config = lib.mkIf cfg.enable {
    # Implementation TBD.
  };
}
