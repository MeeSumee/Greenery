# NIX DOT NIX I ALWAYS WANTED TO NAME IT
{ 
  ... 
}:{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable core nix features
  nix = {
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
