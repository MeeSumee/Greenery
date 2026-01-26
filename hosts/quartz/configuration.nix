/*
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⢿⢰⣍⠶⣉⢞⢰⡄⠀⠀⠀⠀⠀
⠀⣠⢤⣤⡤⣤⢤⢄⠀⠀⠀⠀⢀⢤⣼⠱⠾⠀⠀⠀⢸⣬⣸⡇⠀⠀⠀⠀⠀
⠀⢻⡒⠦⠷⠼⠮⢴⣧⣤⣠⡤⣼⠰⠾⠀⠀⠀⠀⠀⢸⣿⣛⡆⠀⠀⠀⠀⠀
⠀⢸⢍⡃⠀⠀⠀⠸⠿⢿⣛⡵⢪⠀⠀⠀⠀⠀⠀⠀⢸⣿⣝⡆⠀⠀⠀⠀⠀
⠀⣼⢪⠄⠀⠀⠀⠀⠀⠸⠿⢏⢳⠀⠀⠀⠀⠀⠀⢀⢸⣿⡿⠷⢶⠶⣆⠀⠀
⠀⢫⣜⣢⣀⡀⠀⠀⠀⢀⢀⠨⣎⠀⠀⠀⠀⠀⢠⣭⡾⠿⠯⠹⢬⠳⣼⠀⠀
⡄⠀⠀⢟⣻⣧⣤⡄⠀⠐⣎⠑⠊⠀⠀⠀⠀⣀⢸⣿⡇⠀⠀⠀⢸⣵⣾⠀⠀
⠀⣴⣲⢒⡟⣻⣿⣧⠠⡜⣌⠇⠀⠀⠀⠀⠀⡜⣸⣿⡇⠀⢠⣤⣼⣿⠟⠀⠀
⠀⣼⢢⠛⠒⢻⢛⣧⣷⡞⣤⠃⠀⠀⠀⠀⠀⡜⣹⣿⣧⢄⠺⣟⢫⡩⢄⡆⢢
⠀⣼⣷⡇⠀⠈⠁⢸⣿⡗⢢⡅⠀⠀⠀⢤⢰⣶⣿⢛⢫⡌⠇⠈⠁⠉⠘⡜⢸
⠀⢞⣿⡇⠀⠀⠀⠈⠉⢹⣶⡇⠀⠀⠀⢎⠼⣿⣿⣾⡆⠉⠀⠀⠀⠀⢸⣾⢚
⠀⡾⣿⣇⠀⠀⠀⠀⠀⢸⣿⡇⠀⡠⡔⢪⢹⣿⣿⡉⠇⠀⠐⡤⣶⣶⣯⠟⠊
⠀⠘⠛⣿⣶⡆⠀⢀⡒⣾⣿⣷⣶⡧⡙⡜⣸⣿⣿⡈⢇⡒⣾⣷⣿⠛⠋⠀⠀
⠀⠀⠀⠘⠙⣿⣷⣿⣿⣿⠛⠛⠿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣟⡟⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠈⠉⠉⠉⠉⠁⠈⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀
*/

{
  ...
}: {
  imports = [
    # Imports.
    ../../modules
  ];

  # All modules and their values
  greenery = {
    enable = true;
    
    desktop = {
      enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      niri.enable = true;
      # kurukurudm.enable = true;
      sddm.enable = true;
      xserver.enable = true;
    };

    hardware = {
      enable = true;
      amdgpu.enable = true;
      audio.enable = true;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;
      dnscrypt.enable = true;
      openssh.enable = true;
      taildrive.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      aagl.enable = true;
      browser.enable = true;
      foot.enable = true;
      core.enable = true;
      desktop.enable = true;
      heavy.enable = true;
      nvim.enable = true;
      steam.enable = true;
    };

    server = {
      enable = true;
      ollama.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      fonts.enable = true;
      input.enable = true;
      sumee.enable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "sumee" ];

  networking.hostName = "quartz"; # The color of my desktop + piezoelectric shenanigans
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

/*
  This value determines the NixOS release from which the default
  settings for stateful data, like file locations and database versions
  on your system were taken. It‘s perfectly fine and recommended to leave
  this value at the release version of the first install of this system.
  Before changing this value read the documentation for this option
  (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
*/
  system.stateVersion = "25.05"; # Did you read the comment?
}
