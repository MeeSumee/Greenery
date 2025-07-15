{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.modpackfabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_20_1;

      serverProperties = {
        gamemode = "survival";
        difficulty = "hard";
        simulation-distance = 10;
      };

      whitelist = {/* */};

      symlinks = 
      let
        modpack = (pkgs.fetchPackwizModpack {
          url = "https://github.com/MeeSumee/Modpacks/raw/refs/heads/master/Downloads/modpacks/Homestead1.0.1/pack.toml";
          packhash = "";
        });
      in {
  "mods" = "${modpack}/mods";
      };
    };
  };
}
