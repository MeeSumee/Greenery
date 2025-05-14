{
  pkgs,
  modulesPath,
  config,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  networking.hostName = "minecraft";
  system.stateVersion = "25.05";
  virtualisation = {
    graphics = false;
    diskSize = 10 * 1024;
    memorySize = 8 * 1024;
    cores = 4;
    forwardPorts = [
      {
        from = "host";
        host.port = 25565;
        guest.port = 25565;
      }
    ];
  };

  # primary user (yes sumee its you and your wife)
  users = {
    groups = {
      sumee = {};
      minecraft = {};
    };
    users.sumee = {
      enable = true;
      initialPassword = "nahida";
      createHome = true;
      isNormalUser = true;
      uid = 1000;
      group = "sumee";
      extraGroups = ["wheel"];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    gc = {
      persistent = true;
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # starting point for minecraft forge specific configuration
  # largely a derivation of https://gist.github.com/cyber-murmel/4aeae3b5dafc72f12827b3284a9da481
  users = {
    # groups.minecraft = {}; defined earlier
    extraUsers.minecraft = {
      isSystemUser = true;
      group = "minecraft";
      home = "/var/minecraft";
      createHome = true;
      initialPassword = "greatpass";
    };
  };

  systemd.user.tmpfiles.users."sumee".rules = let
    mcVersion = "1.20.1";
    forgeVersion = "47.3.0";
    mcLibs = pkgs.callPackage ../pkgs/mcLibBuilder.nix {
      inherit mcVersion forgeVersion;
      installerHash = "sha256-YBirzpXMBYdo42WGX9fPO9MbXFUyMdr4hdw4X81th1o=";
      libHash = "sha256-8I6tAOAhaQZzjUtbI137pzL6lw/I3taxuK4EZx6cRIs=";
    };
    home = config.users.users.sumee.home;

    # ${pkgs.jdk23}/bin/java -jar ${mcLibs.shim-name} --onlyCheckJava || exit 1
    runner = pkgs.writeShellScriptBin "run.sh" ''
      ${pkgs.jdk17}/bin/java @user_jvm_args.txt @libraries/net/minecraftforge/forge/${mcVersion}-${forgeVersion}/unix_args.txt "$@"
    '';
    user_jvm_args = pkgs.writeText "user_jvm_args.txt" ''
      # Note: Not all server panels support this file. You may need to set these options in the panel itself.
      # Xmx and Xms set the maximum and minimum RAM usage, respectively.
      # They can take any number, followed by an M (for megabyte) or a G (for gigabyte).
      # For example, to set the maximum to 3GB: -Xmx3G
      # To set the minimum to 2.5GB: -Xms2500M

      # A good default for a modded server is 4GB. Do not allocate excessive amounts of RAM as too much may cause lag or crashes.
      # Uncomment the next line to set it. To uncomment, remove the # at the beginning of the line.
      # -Xmx4G
    '';

    # yes
    serverproperties = pkgs.writeText "server.properties" (builtins.concatStringsSep "\n" [
      "enable-jmx-monitoring=false"
      "rcon.port=25575"
      "level-seed="
      "gamemode=survival"
      "enable-command-block=false"
      "enable-query=false"
      "generator-settings={}"
      "enforce-secure-profile=true"
      "level-name=world"
      "motd=A Minecraft Server"
      "query.port=25565"
      "pvp=true"
      "generate-structures=true"
      "max-chained-neighbor-updates=1000000"
      "difficulty=easy"
      "network-compression-threshold=256"
      "max-tick-time=60000"
      "require-resource-pack=false"
      "use-native-transport=true"
      "max-players=20"
      "online-mode=true"
      "enable-status=true"
      "allow-flight=false"
      "initial-disabled-packs="
      "broadcast-rcon-to-ops=true"
      "view-distance=10"
      "server-ip="
      "resource-pack-prompt="
      "allow-nether=true"
      "server-port=25565"
      "enable-rcon=false"
      "sync-chunk-writes=true"
      "op-permission-level=4"
      "prevent-proxy-connections=false"
      "hide-online-players=false"
      "resource-pack="
      "entity-broadcast-range-percentage=100"
      "simulation-distance=10"
      "rcon.password="
      "player-idle-timeout=0"
      "force-gamemode=false"
      "rate-limit=0"
      "hardcore=false"
      "white-list=false"
      "broadcast-console-to-ops=true"
      "spawn-npcs=true"
      "spawn-animals=true"
      "log-ips=true"
      "function-permission-level=2"
      "initial-enabled-packs=vanilla"
      "level-type=minecraft\:normal"
      "text-filtering-config="
      "spawn-monsters=true"
      "enforce-whitelist=false"
      "spawn-protection=16"
      "resource-pack-sha1="
      "max-world-size=29999984"
    ]);
  in [
    "L+ '${home}/forge/libraries' - - - - ${mcLibs}/libraries"
    "L+ '${home}/forge/${mcLibs.shim-name}' - - - - ${mcLibs}/${mcLibs.shim-name}"
    "L+ '${home}/forge/run.sh' - - - - ${runner}/bin/run.sh"
    "L+ '${home}/forge/user_jvm_args.txt' - - - - ${user_jvm_args}"
    "L+ '${home}/forge/server.properties' - - - - ${serverproperties}"
    "f '${home}/forge/eula.txt' 770 sumee sumee - eula=true"
  ];

  systemd.services.modpack = let
    modpack = pkgs.callPackage ../pkgs/modpacks/gravitas.nix {};
    copyModpack = pkgs.writeShellScriptBin "copy.sh" ''
      mkdir -p forge
      cp -r -u ${modpack}/* ./forge
      chown -hR sumee:sumee ./forge
      chmod -hR ug+rwx ./forge
    '';
  in {
    enable = true;
    # we'll prolly have to disable this after first run prolly
    description = "Forge Minecraft Server";
    serviceConfig = {
      ExecStart = "${copyModpack}/bin/copy.sh";
      WorkingDirectory = "${config.users.users.sumee.home}";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services.minecraft = {
    enable = true;
    description = "Forge Minecraft Server";
    serviceConfig = {
      ExecStart = "${config.users.users.sumee.home}/forge/run.sh";
      WorkingDirectory = "${config.users.users.sumee.home}/forge";
      Restart = "always";
      RestartSec = 20;
    };
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
  };

  # opens ports for connecting to the minecraft server
  networking.firewall.allowedTCPPorts = [25565 25575];
  networking.firewall.allowedUDPPorts = [25565 25575];
}
