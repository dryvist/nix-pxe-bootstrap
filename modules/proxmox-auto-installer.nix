# Proxmox auto-installer answer-file server.
#
# Skeleton: only declares the option surface. Implementation lands in the
# `netboot.xyz on Pi: implementation` epic in the dryvist Project.
#
# Behavior (when implemented):
#   - Serve the per-node answer files from `answer-files/proxmox-{b,c,d}.toml`
#     over HTTP at a stable URL the Proxmox auto-installer ISO can fetch.
#   - Fingerprint URL by node MAC or DHCP option so each node gets the right
#     answer file without manual intervention.
{ config, lib, ... }:
let
  cfg = config.services.dryvist.pxe.proxmoxAutoInstaller;
in
{
  options.services.dryvist.pxe.proxmoxAutoInstaller = {
    enable = lib.mkEnableOption "Proxmox auto-installer answer-file HTTP server";

    # Future option surface (unused while enable = false):
    # answerFilesPath = lib.mkOption { type = lib.types.path; default = ../../answer-files; };
    # nodes           = lib.mkOption { type = lib.types.listOf lib.types.str; default = [ "b" "c" "d" ]; };
    # listenPort      = lib.mkOption { type = lib.types.port; default = 8000; };
  };

  config = lib.mkIf cfg.enable {
    # Implementation TBD.
  };
}
