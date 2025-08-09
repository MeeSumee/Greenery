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
    ./kurukurudm.nix
    ./niri.nix
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

    # Hjem for setting face icon and file management
    hjem.users = lib.genAttrs users (user: {
      enable = true;
      directory = config.users.users.${user}.home;
      clobberFiles = lib.mkForce true;
      files = let 
        # Make face.icon at /home/user/
        faceIcon = let
          pfp = pkgs.fetchurl {
            name = "vivianpfp.jpg";
            url = "https://cdn.donmai.us/original/b3/b2/__vivian_banshee_zenless_zone_zero_drawn_by_icetea_art__b3b237c829304f29705f1291118e468f.jpg?download=1";
            hash = "sha256-KQZHp4tOufAOI4utGo8zLpihicMTzF5dRzQPEKc4omI=";
          };
        in
          pkgs.runCommandWith {
            name = "cropped-${pfp.name}";
            derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
          } ''
            magick ${pfp} -crop 1000x1000+210+100 - > $out
          '';

      in {
      ".face.icon".source = faceIcon;
      ".config/mpv".source = ../../dots/mpv;
      ".config/fuzzel/fuzzel.ini".source = ../../dots/fuzzel/fuzzel.ini;
      };
    });

    # Set face icon for all users
    systemd.tmpfiles.rules = lib.pipe users [
      (builtins.filter (user: config.hjem.users.${user}.files.".face.icon".source != null))
      (builtins.map (user: [
        "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
        "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${config.hjem.users.${user}.files.".face.icon".source}"
      ]))
      (lib.flatten)
    ];
  };
}
