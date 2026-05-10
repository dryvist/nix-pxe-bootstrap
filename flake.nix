{
  description = "dryvist PXE bootstrap host — netboot.xyz + Proxmox auto-installer (skeleton)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      sops-nix,
      disko,
      ...
    }:
    let
      # PXE host is small / single-arch; default to aarch64 for Pi but
      # leave the door open for x86_64 (N100 / N305 mini-PC).
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Quality checks shared with CI (mirrors nix-darwin pattern).
      checksFor =
        sys:
        import ./lib/checks.nix {
          pkgs = nixpkgs.legacyPackages.${sys};
          src = ./.;
        };
    in
    {
      nixosConfigurations.pxe-host = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit nixos-hardware; };
        modules = [
          # Hardware module — swap raspberry-pi-4 for a different model
          # (or drop entirely for x86_64) when target hardware is bound.
          nixos-hardware.nixosModules.raspberry-pi-4

          disko.nixosModules.disko
          sops-nix.nixosModules.sops

          ./hosts/pxe-host
        ];
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;

      checks = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ] checksFor;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt-rfc-style
          statix
          deadnix
          sops
          age
          ssh-to-age
          mermaid-cli
        ];
      };
    };
}
