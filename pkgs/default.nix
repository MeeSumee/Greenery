{
  pkgs,
  lib,
  ...
}:
lib.fix (self: let
  inherit (pkgs) callPackage;
  # NOTE TO SELF
  # If you're unsure what the new revision format is, just type main or random characters
  # and the caddy build will tell you the correct revision
  revision = "v0.0.0-20260826180304-de41b249af4f";
in {
  stmc-cursor = callPackage ./stmc.nix {};
  davinci = callPackage ./davinci.nix {};
  frigate-yolo-model = callPackage ./frigate-yolo-model.nix {};
  dickord = pkgs.equibop.override {
    withTTS = false;
    withMiddleClickScroll = true;
  };
  caddyscale = pkgs.caddy.withPlugins {
    plugins = [
      "github.com/tailscale/caddy-tailscale@${revision}"
      # "github.com/caddy-dns/cloudflare@v0.2.4"
    ];
    hash = "sha256-tR+Da52Ozvwtk7LcCM9DFmDwcKxLd/u+2VmOTs1JFsI=";
  };
})
