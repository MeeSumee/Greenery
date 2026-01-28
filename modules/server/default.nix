{ 
  lib,
  config,
  ... 
}: {

  imports = [
    ./anki.nix
    ./auth.nix
    ./davis.nix
    ./files.nix
    ./immich.nix
    ./jellyfin.nix
    ./memos.nix
    ./ollama.nix
    ./suwayomi.nix
  ];
  
  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

  config = lib.mkIf config.greenery.server.enable {

    # Enable GNU Screen
    programs.screen.enable = true;
  };
}
