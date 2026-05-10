# netboot.xyz — boot menu / iPXE chainload entry for cluster nodes.
#
# Skeleton: only declares the option surface. Implementation lands in the
# `netboot.xyz on Pi: implementation` epic in the dryvist Project.
{ config, lib, ... }:
let
  cfg = config.services.dryvist.pxe.netbootxyz;
in
{
  options.services.dryvist.pxe.netbootxyz = {
    enable = lib.mkEnableOption "netboot.xyz boot menu / iPXE chainload";

    # Future option surface (unused while enable = false):
    # tftpRoot       = lib.mkOption { type = lib.types.path; default = "/srv/tftp"; };
    # menuUrl        = lib.mkOption { type = lib.types.str; default = "https://boot.netboot.xyz"; };
    # bindInterface  = lib.mkOption { type = lib.types.str; default = "eth0"; };
  };

  config = lib.mkIf cfg.enable {
    # Implementation TBD. This block is intentionally empty so the module
    # evaluates as a no-op until the epic picks it up.
  };
}
