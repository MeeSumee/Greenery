# NIX DOT NIX I ALWAYS WANTED TO NAME IT
{ 
  sources,
  ... 
}:{

  # Essential config changes
  nixpkgs = {
    config.allowUnfree = true;
    flake.source = sources.nixpkgs;
  };

  # Enable core nix features
  nix = {
    channel.enable = false;
    settings = {
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
