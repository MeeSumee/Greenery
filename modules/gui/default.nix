{
  config,
  pkgs,
  options,
  lib,
  sources,
  users,
  ...
}:{
  imports = [
    # Import files
    ./gnome.nix
    ./gdm.nix
    ./inputfont.nix
    ./programs.nix
    ./audio.nix
    ./hyprland.nix
    ./niri.nix
#    ./sddm.nix

    # Hjem source
    (sources.hjem + "/modules/nixos")
  ];
  
  # Set default editor
  environment.variables = {
    EDITOR = "micro";
    SYSTEMD_EDITOR = "micro";
    VISUAL = "micro";
  };
  
  # Session variables for wayland usage + speeding up walker
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GSK_RENDER = "cairo";
  };
  
  # Set defaults
  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "foot.desktop"
        ];
      };
    };
    mime.defaultApplications = {
      "image" = "qimgv.desktop";
    };
  };
  
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    displayManager = {
      setupCommands = ''
      '';
    };
    videoDrivers = [ "amdgpu" ];
  };

  # Pokit Agent (Do I need this??)
  #security.soteria.enable = true;
  
  # Hjem for simple home management
  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/mpv".source = ../../dots/mpv;
      ".config/foot/foot.ini".source = ../../dots/foot/foot.ini;
      ".config/walker/config.toml".source = ../../dots/walker/config.toml;
      ".config/fish/config.fish".source = ../../dots/fish/config.fish;
      ".config/fish/themes/Rosé Pine.theme".source = ../../dots/fish/themes/rosepine.theme;
      ".librewolf/librewolf.overrides.cfg".source = ../../dots/librewolf/librewolf.overrides.cfg;
    };
  });  
}
