# Disk layout — PLACEHOLDER.
#
# The real layout depends on the chosen target hardware:
#   - Raspberry Pi 4/5: SD card or USB-attached SSD/NVMe (single device).
#   - N100/N305 mini-PC: NVMe (single device, GPT, ESP + ext4 root or btrfs).
#
# Real /dev/disk/by-id/* paths land here in a follow-up PR after the device
# exists. Do NOT hard-code /dev/sda or /dev/nvme0n1 — by-id paths only.
#
# This file currently sets `disko.devices = {}` so `nix flake check` evaluates
# without trying to assemble a fake disk layout. The implementation epic in
# the dryvist Project will replace this with a real layout.
_:
{
  disko.devices = {
    # Example layout to fill in later — kept here as documentation:
    #
    # disk.main = {
    #   type = "disk";
    #   device = "/dev/disk/by-id/<replace-me>";
    #   content = {
    #     type = "gpt";
    #     partitions = {
    #       ESP = {
    #         size = "512M";
    #         type = "EF00";
    #         content = {
    #           type = "filesystem";
    #           format = "vfat";
    #           mountpoint = "/boot";
    #         };
    #       };
    #       root = {
    #         size = "100%";
    #         content = {
    #           type = "filesystem";
    #           format = "ext4";
    #           mountpoint = "/";
    #         };
    #       };
    #     };
    #   };
    # };
  };
}
