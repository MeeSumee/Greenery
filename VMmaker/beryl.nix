# Beryl Virtual Machine, note that this config has no hardware modifications
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    # Imports
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.hostName = "berylVM"; # Virtual Machine Name
  system.stateVersion = "25.05"; # Default state version
  virtualisation = {
    graphics = true; # Enable Graphics
    diskSize = 10 * 1024; # Set Disk Size in GB
    memorySize = 6 * 1024; # Set Memory Allocation in GB
    cores = 4; # Set number of cores
    forwardPorts = [
      {
        from = "host";
        host.port = 8080; # Port 8080 for web access
        guest.port = 8080;
      }
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;  

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  users = {
    groups = {
      beryl = {};
    };
    users.beryl = {
      enable = true;
      initialPassword = "";
      createHome = true;
      isNormalUser = true;
      uid = 1000;
      group = "beryl";
      extraGroups = [ "qemu-libvirtd" "libvirtd" "wheel" "video" "audio"];
    };
  };
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  # Set internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ja_JP.UTF-8" ] ;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Font Settings for both English and Japanese
  fonts.packages = with pkgs; [
    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];
  
  # Enable fcitx for Input Method Editor (IME)
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };
  
  # Enable mozc as input method in fcitx. Good for JP input.
  i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];
  
  # Provides ibus for input method
  environment.variables.GLFW_IM_MODULE = "ibus";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Firefox
  programs.firefox.enable = true;
  
  # Gaseous H2O
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; #Firewall port for steam remote play
    dedicatedServer.openFirewall = true; #Firewall port for dedicated server
    localNetworkGameTransfers.openFirewall = true; #Firewall port for local network game transfers
    gamescopeSession.enable = true;
  };
  
  # Java
  programs.java.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
/*  
    if you use "with pkgs;", elements inside the 
    list don't need the "pkgs.<pkgname>" syntax
    if you remove the "with pkgs;" line, then you will need to
    call below as pkgs.<pkgname> (which is what I prefer personally)
    why did I choose to remove pkgs.<pkgname>? MethLab 
*/
    (pkgs.discord.override { enableAutoscroll = true; }) # Discord + Auto Scroll Option
    brave # Import Browser Profiles
    vim # Vim editor (I'm not good at it)
    btop # System Monitor
    sbctl # Secure Boot Control
    pkgs.win2xcur # Win2Linux Cursor Conversion Tool
    git # Self-explanatory
    openshot-qt # Video Editing
    gimp3 # Image Manipulation
    foliate # e-book reader
    wineWowPackages.waylandFull # Wine
    xournalpp # Note taking
    vlc # Media Player
    libreoffice-fresh # MSOffice Alternative
    gparted # Disk Partitioning
    prismlauncher # Minecraft
    zoom-us # Meetings
    arduino-ide # Programming
    gnome-tweaks # Nahida Cursors & Other Cool Stuff >.<
  ];

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  # Enable tailscale VPN service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };
}
