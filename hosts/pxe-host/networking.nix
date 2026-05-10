# Networking — PLACEHOLDER.
#
# Real values land in a follow-up PR after the IP plan for the cluster mgmt
# VLAN is finalized. Today this file only declares the SHAPE of the config so
# evaluators can see what knobs exist.
{ lib, ... }:
{
  networking = {
    # Placeholder static IP on the management VLAN — replace before deploy.
    interfaces.eth0.ipv4.addresses = lib.mkDefault [
      {
        address = "192.168.0.10";
        prefixLength = 24;
      }
    ];

    defaultGateway = lib.mkDefault {
      address = "192.168.0.1";
      interface = "eth0";
    };

    nameservers = lib.mkDefault [
      "192.168.0.1"
    ];

    # PXE host serves on UDP/69 (TFTP) + TCP/80 (HTTP, nginx-static).
    # Firewall rules will be enabled by the netbootxyz / nginx-static modules
    # once their bodies are implemented.
    firewall.enable = lib.mkDefault true;
  };
}
