# Graphite Configuration
{
  lib,
  inputs,
  pkgs,
  ... 
}: {
  imports = [
    ../../modules
    inputs.wsl.nixosModules.default
  ];

  # All modules and their values
  greenery = {
    enable = true;

    hardware = {
      enable = true;
    };

    networking = {
      enable = true;
      openssh.enable = true;
    };

    programs = {
      enable = true;
      core.enable = true;
      nvim.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      sumee.enable = true;
    };
  };

  networking.hostName = "graphite"; # The workplace grindset + friend made me do it
  networking.wireless.enable = lib.mkForce false;

  # Enable WSL Features
  wsl = {
    enable = true;
    defaultUser = "sumee";
    wslConf.interop.appendWindowsPath = false;
  };

  # Pythong
  environment.systemPackages = with pkgs; [
    uv
  ];

  # Fix python dynamic linking
  programs.nix-ld.enable = true;

  # Disable Greenery Core Services
  services = {
    printing.enable = lib.mkForce false;
    gvfs.enable = lib.mkForce false;
    udisks2.enable = lib.mkForce false;
    fwupd.enable = lib.mkForce false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
