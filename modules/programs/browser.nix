{
  config,
  options,
  lib,
  pkgs,
  ...
}:{

  options.greenery.programs.browser.enable = lib.mkEnableOption "brave and librewolf";

  config = lib.mkIf (config.greenery.programs.browser.enable && config.greenery.programs.enable) {

    # Librewolf Browser
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;
    };
    
    # Brave browser
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}