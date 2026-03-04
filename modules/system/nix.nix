# NIX DOT NIX I ALWAYS WANTED TO NAME IT
{ 
  inputs,
  pkgs,
  ... 
}:{

  # Essential config changes
  nixpkgs = {
    config.allowUnfree = true;
  };

  # Enable core nix features
  nix = {
    package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    settings = {
      allow-import-from-derivation = false;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];

      extra-substituters = ["https://sumee.cachix.org"];
      extra-trusted-public-keys = ["sumee.cachix.org-1:Hq6j5JXABEiSpFsSMwAJLiAclMmBpdP+gsUgVy2Ld4Y="];
    };
    
    # Nix auto garbage collect 
    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
