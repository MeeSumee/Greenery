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
    package = pkgs.nixVersions.nix_2_30;
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    settings = {
      allow-import-from-derivation = false;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
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
