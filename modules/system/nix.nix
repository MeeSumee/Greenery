# NIX DOT NIX I ALWAYS WANTED TO NAME IT
{ 
  ... 
}:{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set performance profile
  systemd.slices.anti-hungry.sliceConfig = {
    CPUAccounting = true;
    CPUQuota = "80%";
    MemoryAccounting = true; # Allow to control with systemd-cgtop
    MemoryHigh = "60%";
    MemoryMax = "80%";
    MemorySwapMax = "50%";
    MemoryZSwapMax = "50%";
  };

  # Set nix-daemon to use profile to not eat up RAM
  systemd.services.nix-daemon.serviceConfig.Slice = "anti-hungry.slice";


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
