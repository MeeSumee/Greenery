{
  pkgs,
  inputs,
  config,
  lib,
  users,
  ...    
}: let
    zero-bg = pkgs.fetchurl {
      name = "lockbg.png";
      url = "https://img4.gelbooru.com/images/62/f3/62f3da5821dab06f98cfaf71dc304243.png";
      hash = "sha256-X6zdZVYi6iyGc1M065lNlcqMBVQ21RMX2IKOGAzkzqE=";
    };
    
    sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
      theme = "default";
      extraBackgrounds = [zero-bg];
      theme-overrides = {
          "LoginScreen.LoginArea.Avatar" = {
            shape = "circle";
            active-border-size = 0;
            inactive-border-size = 0;
          };
          
		  "LockScreen.Date" = {
		    font-size = 24;	
		  };
          
          "LoginScreen" = {
            background = "${zero-bg.name}";
          };
          
          "LockScreen" = {
            background = "${zero-bg.name}";
          };
      };
    };

in {
  environment.systemPackages = [sddm-theme];
  qt.enable = true;
  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    enable = true;
    enableHidpi = true;

    wayland = {
      enable = true;
      compositorCommand = "${lib.getExe' pkgs.kdePackages.kwin "kwin_wayland"} --drm --no-lockscreen --no-global-shortcuts --locale1";
    };
    
    theme = sddm-theme.pname;
    extraPackages = sddm-theme.propagatedBuildInputs;
    
    settings = {
      Theme = {
      	CursorTheme = "xcursor-genshin-nahida";
      	CursorSize = 24;
      };
      General = {
        GreeterEnvironment = builtins.concatStringsSep "," [
          "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/"
          "QT_IM_MODULE=qtvirtualkeyboard"
        ];
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };

  # Use .face.icon and import into user variables
  systemd.tmpfiles.rules = let
    iconPath = user: config.hjem.users.${user}.files.".face.icon".source;
  in
    lib.pipe users [
      (builtins.filter (user: (iconPath user) != null))
      (builtins.map (user: [
        "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
        "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${iconPath user}"
      ]))
      (lib.flatten)
    ];
}
