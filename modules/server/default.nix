{
  lib,
  config,
  pkgs,
  ...
}: let
  revision = "bb080c4414acd465d8be93b4d8f907dbb2ab2544";
in {
  imports = [
    ./anki.nix
    ./auth.nix
    ./davis.nix
    ./files.nix
    ./home.nix
    ./immich.nix
    ./jellyfin.nix
    ./memos.nix
    ./ollama.nix
    ./suwayomi.nix
  ];

  options.greenery.server.enable = lib.mkEnableOption "enable server modules";

  config = lib.mkIf config.greenery.server.enable {
    # Enable GNU Screen
    programs.screen = {
      enable = true;
      screenrc = ''
        startup_message off
        vbell off
        altscreen on
        termcapinfo rxvt* 'hs:ts=\E]2;:fs=\007:ds=\E]2;\007'
        truecolor on
        hardstatus off
        hardstatus alwayslastline '%{#00ff00}[ %H ][%{#ffffff}%= %{7}%?%-Lw%?%{1;0}%{1}(%{15}%n%f%t%?(%u)%?%{1;0}%{1})%{7}%?%+Lw%? %=%{#00ff00}][ %{#00a5ff}%{6}%Y-%m-%d %{#ffffff}%{7}%0c%{#00ff00} ]'
      '';
    };

    # Caddy Secret
    age.secrets.secret7.file = ../../secrets/secret7.age;

    # Caddy-tailscale plugin to get subdomains
    services.caddy = {
      environmentFile = config.age.secrets.secret7.path;
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/tailscale/caddy-tailscale@${revision}"];
        hash = "";
      };

      # Age file has contents TS_AUTH=<insert your auth key>
      globalConfig = ''
        tailscale {
          auth_key {$TS_AUTH}
        }
      '';
    };
  };
}
