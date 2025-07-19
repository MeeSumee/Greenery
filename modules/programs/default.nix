{
  lib,
  options,
  config,
  ...
}:{

  imports = [
    ./aagl.nix
    ./browser.nix
    ./foot.nix
    ./micro.nix
    ./nixpkgs.nix
    ./nvim.nix    
    ./steam.nix
    ./yazi.nix
  ];
  
  options.greenery.programs.enable = lib.mkEnableOption "programs";

  config = lib.mkIf config.greenery.programs.enable {
    
    # Set default editor
    environment.variables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };

    # Set default applications
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
  };
}