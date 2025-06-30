# Importer and Defaults maker
{
  config,
  pkgs,
  options,
  lib,
  inputs,
  ...
}:{
  imports = [
    ./fish.nix
    ./networking.nix
    ./locale.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Universal Packages
  environment.systemPackages = with pkgs; [
    git
    wget
    micro
    neovim
    btop
    tree
    unzip
    speedtest-cli
    fzf
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable essential features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  # Enable Firmware Updates
  services.fwupd.enable = true;

}
