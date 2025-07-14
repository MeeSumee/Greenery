{
  config,
  pkgs,
  options,
  lib,
  inputs,
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

    # Flake Inputs
    inputs.hjem.nixosModules.default
  ];

  environment.variables = {
    EDITOR = "micro";
    SYSTEMD_EDITOR = "micro";
    VISUAL = "micro";
  };
  
  # Forces applications to use wayland instead of Xwayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # Common GUI packages
  environment.systemPackages = with pkgs; [
    fuzzel # app manager
    wl-clipboard # clipboard manager
    cliphist # clipboard history
    wl-screenrec # screen recorder
    imv # image viewer? need to talk to rex about it
    brightnessctl # brightness ctl so my eyes don't  hurt
    inputs.quickshell.packages.${pkgs.system}.default # quickshell (still not done)
    wlsunset # I need fucking blue light filter, my fucking eyes hurt
  ];

  # Exclude xterm
  services.xserver.excludePackages = with pkgs; [ xterm ];
  
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
  	displayManager = {
  	  setupCommands = ''
  	  '';
  	};
  	videoDrivers = [ "amdgpu" ];
  };
  
  # Seahorse Password Manager (Do I need this?)
  programs.seahorse.enable = true;

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;

  # Pokit Agent (Do I need this??)
  security.soteria.enable = true;

  # Pam Services and fixing Gnome Keyring Popups (DOES THIS EVEN WORK???)
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  # Gnome Keyring Packages (I dunno why keyring keeps complaining when I open brave)
  services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
  
  # Hjem for simple home management
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
      ".config/foot/foot.ini".source = ../../dots/foot/foot.ini;
      ".config/fuzzel/fuzzel.ini".source = ../../dots/fuzzel/fuzzel.ini;
      ".config/fish/config.fish".source = ../../dots/fish/config.fish;
      ".config/fish/themes/Rosé Pine.theme".source = ../../dots/fish/themes/rosepine.theme;
      ".librewolf/librewolf.overrides.cfg".source = ../../dots/librewolf/librewolf.overrides.cfg;
    };
  });  
}
