{
  pkgs,
  lib,
  ...
}:
lib.fix (self: let
  inherit (pkgs) callPackage;
  revision = "v0.0.0-20260106222316-bb080c4414ac";
in {
  stmc-cursor = callPackage ./stmc.nix {};
  davinci = callPackage ./davinci.nix {};
  dickord = pkgs.equibop.override {
    withTTS = false;
    withMiddleClickScroll = true;
  };
  caddyscale = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/tailscale/caddy-tailscale@${revision}"
      # "github.com/caddy-dns/cloudflare@v0.2.4"
    ];
    hash = "sha256-XBdYjtuPVu/beIgFgFcVp6ln4r9kq0B6+4xJ8+WWYn0=";
  };
})
