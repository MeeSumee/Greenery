{
  lib,
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
    ./vm.nix
  ];
  
  options.greenery.programs.enable = lib.mkEnableOption "programs";

  config = lib.mkIf config.greenery.programs.enable {
    
    # Disable nano
    programs.nano.enable = false;

    # Enable git
    programs.git.enable = true;

    # Set default editor
    environment.variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
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
