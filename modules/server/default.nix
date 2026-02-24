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
  };
}
