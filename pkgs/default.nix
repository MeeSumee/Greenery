{
  pkgs,
  lib,
  ...
}:
lib.fix (self: let
  inherit (pkgs) callPackage;
  revision = "v0.0.0-20260106222316-bb080c4414ac";
in {
  nahidacursor = callPackage ./cursors.nix {};
  davinci = callPackage ./davinci.nix {};
  papiteal = pkgs.papirus-icon-theme.override {color = "teal";};
  dickord = pkgs.equibop.override {
    withTTS = false;
    withMiddleClickScroll = true;
  };
  caddyscale = pkgs.caddy.withPlugins {
    plugins = ["github.com/tailscale/caddy-tailscale@${revision}"];
    hash = "sha256-xJOPVE56h4tlhW7m8ZFN8F2jrZW/3gYeLXVqaEaoVvY=";
  };
})
