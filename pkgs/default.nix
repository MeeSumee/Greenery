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
    plugins = ["github.com/tailscale/caddy-tailscale@${revision}"];
    hash = "sha256-iUQXsmUJEdOpv6uXte73RXFOhxfzwb/r9vdCTVXjP4Y=";
  };
})
