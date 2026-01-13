{
  pkgs,
  lib,
  ...
}: lib.fix (self: let
  inherit (pkgs) callPackage;
in {
  nahidacursor = callPackage ./cursors.nix {};

  papiteal = pkgs.papirus-icon-theme.override {
    color = "teal";
  };

  vesktop = pkgs.vesktop.override {
    withTTS = false;
    withMiddleClickScroll = true;
  };
})
