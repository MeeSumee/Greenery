{
  lib,
  config,
  pkgs,
  ...
}: {
  # Used for building VMs or nixos-shell from Mic92
  # I generally use nix run nixpkgs#nixos-shell -- --flake .#hostname
  options.test.enable = lib.mkEnableOption "test nixos as a VM";

  config = lib.mkIf config.greenery.test.enable {
    users.users.uwu = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "autism";
    };

    virtualisation = {
      memorySize = 4096;
      cores = 4;
      diskSize = 20 * 1024;
      qemu.options = [
        "-bios"
        "${pkgs.OVMF.fd}/FV/OVMF.fd"
      ];
    };

    # Overrides
    greenery = {
      hardware = {
        intelgpu.enable = lib.mkForce false;
      };

      programs = {
        nvim.enable = lib.mkForce false;
      };

      system = {
        lanzaboote.enable = lib.mkForce false;
        sumee.enable = lib.mkForce false;
      };
    };
  };
}
