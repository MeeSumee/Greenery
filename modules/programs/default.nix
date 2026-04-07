{lib, ...}: {
  imports = [
    ./aagl.nix
    ./chromium.nix
    ./foot.nix
    ./fuzzel.nix
    ./git.nix
    ./micro.nix
    ./nixpkgs.nix
    ./nvim.nix
    ./steam.nix
    ./sunshine.nix
    ./vm.nix
  ];

  options.greenery.programs.enable = lib.mkEnableOption "programs";
}
