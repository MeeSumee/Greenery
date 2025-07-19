{
  config,
  options,
  lib,
  ...
}:{

  options.greenery.programs.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf (config.greenery.programs.steam.enable && config.greenery.programs.enable) {

    # Gaseous H2O
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;                # Firewall port for steam remote play
      dedicatedServer.openFirewall = true;           # Firewall port for dedicated server
      localNetworkGameTransfers.openFirewall = true; # Firewall port for local network game transfers
      gamescopeSession.enable = true;                # Gamescope for native xwayland windows
    };
  };
}