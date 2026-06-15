# NIX DOT NIX I ALWAYS WANTED TO NAME IT
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  nixpkgs = {
    # Pure libre isn't exactly feasible
    config.allowUnfree = true;
  };

  # Enable core nix features
  nix = {
    # Garbage collect okay for kaolin as VPS SSDs have redundancy
    gc = lib.mkIf (config.networking.hostName == "kaolin") {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    settings = {
      flake-registry = "/etc/nix/registry.json";
      allow-import-from-derivation = false;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];

      # fuck this
      warn-dirty = false;

      # Cache stuff
      builders-use-substitutes = true;
      extra-substituters = ["https://sumee.cachix.org"];
      extra-trusted-public-keys = ["sumee.cachix.org-1:Hq6j5JXABEiSpFsSMwAJLiAclMmBpdP+gsUgVy2Ld4Y="];
    };
  };

  # Uses /var/tmp instead of tmpfs for building
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/var/tmp";
  };
}
