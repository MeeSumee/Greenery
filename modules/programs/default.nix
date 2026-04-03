{
  lib,
  config,
  ...
}: {
  imports = [
    ./aagl.nix
    ./chromium.nix
    ./foot.nix
    ./fuzzel.nix
    ./micro.nix
    ./nixpkgs.nix
    ./nvim.nix
    ./rustdesk.nix
    ./steam.nix
    ./sunshine.nix
    ./vm.nix
  ];

  options.greenery.programs.enable = lib.mkEnableOption "programs";

  config = lib.mkIf config.greenery.programs.enable {
    # Enable git
    programs.git.enable = true;
  };
}
