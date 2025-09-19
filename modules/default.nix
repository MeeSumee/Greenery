{
  lib,
  ...
}:{
  imports = [
    ./desktop
    ./hardware
    ./networking    
    ./programs
    ./server
    ./system
  ];
  
  # Do you really want to disable every single file in modules lmfao??
  options.greenery.enable = lib.mkEnableOption "すべて";

/*
  This is for reference for all NixOS systems

  greenery = {
    enable = true;
    
    desktop = {
      enable = true;
      gdm.enable = true;
      gnome.enable = true;
      hypridle.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      kurukurudm.enable = true;
      niri.enable = true;
      xserver.enable = true;
    };

    hardware = {
      enable = true;
      amdgpu.enable = true;
      audio.enable = true;
      intelgpu.enable = true;
      power.enable = true;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;      
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      taildrive.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      aagl.enable = true;
      browser.enable = true;
      foot.enable = true;
      micro.enable = true;
      core.enable = true;
      server.enable  = true;
      daemon.enable = true;
      desktop.enable = true;
      engineering.enable = true;
      heavy.enable = true;
      nvim.enable = true;
      steam.enable = true;
      yazi.enable = true;
    };

    server = {
      enable = true;
      davis.enable = true;
      files.enable = true;
      jellyfin.enable = true;
      remotevm.enable = true;
      suwayomi.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = true;
      input.enable = true;
      lanzaboote.enable = true;
      sumee.enable = true;
      nahida.enable = true;
      yang.enable = true;

      age.nix included by default
      locale.nix included by default
      nix.nix included by default
    };
  };
*/
}
