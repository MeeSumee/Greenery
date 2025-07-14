# Importer and Defaults maker
{
  pkgs,
  ...
}:{
  imports = [
    ./fish.nix
    ./networking.nix
    ./locale.nix
    ./nvim.nix
    ./micro.nix
    ./yazi.nix
    ./nix.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Universal Packages
  environment.systemPackages = with pkgs; [
    npins
    git
    wget
    btop
    tree
    unzip
    speedtest-cli
    fzf
  ];

  # Disable nano
  programs.nano.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  # Enable Firmware Updates
  services.fwupd.enable = true;
}
