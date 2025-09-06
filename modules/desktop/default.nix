{
  config,
  lib,
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
    ./kurukurudm.nix
    ./niri.nix
    ./xserver.nix
  ];
  
  options.greenery.desktop.enable = lib.mkEnableOption "desktop enviroment";

  config = lib.mkIf config.greenery.desktop.enable {

    # Session variables for wayland usage
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    # Hjem for file management
    hjem.users = lib.genAttrs users (user: {
      files = {
        ".config/mpv".source = ../../dots/mpv;
        ".config/fuzzel/fuzzel.ini".source = ../../dots/fuzzel/fuzzel.ini;
      };
    });

  };
}
