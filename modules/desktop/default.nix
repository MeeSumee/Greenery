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
    ./gdm.nix
    ./gnome.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./niri.nix
#    ./sddm.nix
    ./xserver.nix

    # Hjem source
    (sources.hjem + "/modules/nixos")
  ];
  
  options.greenery.desktop.enable = lib.mkEnableOption "desktop enviroment";

  config = lib.mkIf config.greenery.desktop.enable {

    # Session variables for wayland usage
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    # Hjem for simple home management
    hjem.users = lib.genAttrs users (user: {
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = {
        ".config/mpv".source = ../../dots/mpv;
        ".config/fuzzel/fuzzel.ini".source = ../../dots/fuzzel/fuzzel.ini;
      };
    });  
  };
}
