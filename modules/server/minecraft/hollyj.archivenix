{
  pkgs,
  config,
  ...
}: {
  services.minecraft-servers = {
    servers.hollyj = {
      package = pkgs.fabricServers.fabric-1_21_1;
      enable = true;

      # start with: systemctl start minecraft-server-hollyj.service
      autoStart = true;
      openFirewall = true;
      enableReload = true;
      restart = "no";
      jvmOpts =
        builtins.concatStringsSep
        " "
        [
          "-Xms1024M"
          "-Xmx6144M"
        ];

      serverProperties = {
        server-port = 8043;
        difficulty = "hard";
        max-players = 20;
        enforce-secure-profile = false;
        online-mode = false;
        motd = "Prepare Za Balls";
        enable-rcon = true;
        "rcon.port" = 8044;
        "rcon.password" = "@rcpwd@";
      };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          # API
          FabricApi = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/4AkOEqGy/fabric-api-0.115.6%2B1.21.1.jar";
            hash = "sha256-3uxy7NelpOETQhGl99X0mrTjh/PmrHsXKwfobyNL1mc=";
          };

          ForgeConfigAPi = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ohNO6lps/versions/NqVx7ywO/ForgeConfigAPIPort-v21.1.3-1.21.1-Fabric.jar";
            hash = "sha256-zGZTTJc/ydRmp4nT1GpOv9vqCb5IHAoOfdzHXr5VxjU=";
          };

          ClothConfigAPI = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/9s6osm5g/versions/HpMb5wGb/cloth-config-15.0.140-fabric.jar";
            hash = "sha256-M4lOldo69ZAUs50SZYbVJB4H6jn4YYdj4w2rY3QF+V8=";
          };

          # AUTH
          EasyAuth = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/aZj58GfX/versions/YmAaUUrO/easyauth-mc1.21-3.2.1.jar";
            hash = "sha256-/iQrriwezkHPuUp757JzlWW/AzTe4kscGJmuXKlzUpE=";
          };

          # OPTIMIZATIONS
          C2ME = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VSNURh3q/versions/ysBifeyb/c2me-fabric-mc1.21.1-0.3.0%2Balpha.0.319.jar";
            hash = "sha256-227IFessxReHdmuwXy7eXJLKAmA0AXhJENdwu4aones=";
          };

          Krypton = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
            hash = "sha256-lPGVgZsk5dpk7/3J2hXN2Eg2zHXo/w/QmLq2vC9J4/4=";
          };

          Lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/MM5BBBOK/lithium-fabric-0.15.0%2Bmc1.21.1.jar";
            hash = "sha256-1f6NMZXqxbLN/6AO1+MHdWDGTSBkuIIhzeoNntBQBLY=";
          };

          FerriteCore = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/uXXizFIs/versions/bwKMSBhn/ferritecore-7.0.2-hotfix-fabric.jar";
            hash = "sha256-4/ro4yFHSjXpT5uwnq/QRAzg/pj0rrvAZ+OSiJcApPo=";
          };

          AlternateCurrent = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/78P98rac/alternate-current-mc1.21-1.9.0.jar";
            hash = "sha256-dVIKG6dbfx+xNQihEYKMNAbFCaBVfGS1sfKYYqsQ1gY=";
          };

          Spark = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/l6YH9Als/versions/cALUj9l1/spark-1.10.109-fabric.jar";
            hash = "sha256-+vwSGsU9qxwy50t6HK5H1UQ1uky+7aEYDclmdad1cEc=";
          };

          Slumber = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ksm6XRZ9/versions/mPf1P26X/slumber-1.2.0.jar";
            hash = "sha256-Rx+7HuHsYjolTr0dxqUWncxjB63TBZ+vIrFXJicXF7I=";
          };

          # UTILITY
          SkinRestorer = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/lLFShhsz/skinrestorer-2.3.0%2B1.21-fabric.jar";
            hash = "sha256-u04u9fXrbzz/1wMZN79mm/DVC6sfBzk/rSXrj8RPgXk=";
          };

          UniversalGraves = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/yn9u3ypm/versions/Fg64B87Y/graves-3.4.4%2B1.21.jar";
            hash = "sha256-O0bdwJEbi/wrpuq64D9wca/ui1gWo/ERBNeJkHOgI9M=";
          };

          BetterThanMending = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Lvv4SHrK/versions/xv5fSPWX/BetterThanMending-2.2.0.jar";
            hash = "sha256-2776x8pbQwJTjdqCfzZadB3HoVNytk8CoHq9pHosERs=";
          };

          Crowmap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/EAe3MQt5/versions/gMrVQcEJ/crowmap-1.21.1-1.1.0.jar";
            hash = "sha256-zJzC+E0j+ZTF9ZDbJhXtLPV9ZR6zzu6qDbqflfeLXu4=";
          };

          Chunky = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/fALzjamp/versions/RVFHfo1D/Chunky-Fabric-1.4.23.jar";
            hash = "sha256-NBKxcCR93nNR4JRdhX5xO+32+uBaswCqdNBv+94MoH4=";
          };

          Leukocyte = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/hsRVgp6Q/versions/hqsHvIy7/leukocyte-0.3.9%2B1.21.1.jar";
            hash = "sha256-girfpCJLeijqpdZVPzadwSysFf1TEPUyRLY3PbL7W44=";
          };

          StyledPlayerList = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/DQIfKUHf/versions/Ui7MOgqG/styledplayerlist-3.5.1%2B1.21.jar";
            hash = "sha256-JdgiYJRuWuJcaDgfqV6JDi8aV/8UIzwTY2aipVVmMZY=";
          };

          FallingTree = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/JtSM2Voq/FallingTree-1.21.1-1.21.1.7.jar";
            hash = "sha256-TJKotvK+5IvkPxByXdAZEIE9CdV+6IpUfvUqKBKjwM8=";
          };

          squaremap = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/PFb7ZqK6/versions/RerxbGKf/squaremap-fabric-mc1.21.1-1.3.2.jar";
            hash = "sha256-rfan0yawlWs4l7jfU4xeM0QO55TjWb4L7S2GAR4HfFw=";
          };

          DayDream = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/FKi0XGBk/versions/hQG5HJLT/day-dream-1.0.11.jar";
            hash = "sha256-nGjKtBN0Ny4U0JaN+3zEIQNFwWAzmQodlpZnZe3idtY=";
          };

          EssentialCommands = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/6VdDUivB/versions/kev3hDqV/essential_commands-0.35.2-mc1.21.jar";
            hash = "sha256-OykygzXT6Uv/J5l516Kvu0ivAeVzg2PsAUwCOT8p7Bg=";
          };

          FabricSeasons = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/KJe6y9Eu/versions/2mIvRTNp/fabric-seasons-2.4.2-BETA%2B1.21.jar";
            hash = "sha256-X3mpTsDpih54se/6kvHCX2L9eC1OEcRCi6mderXneRc=";
          };

          HigherNether = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VfnkzpKJ/versions/HCepdcBB/HigherNether-1.0.2.jar";
            hash = "sha256-5hJe2a5eheD7izzIm/DSvzUyQRorgTfg1KAfSbK6MVY=";
          };

          PatboxBrewery = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/nr7cSJlY/versions/dFY4EIfX/brewery-0.8.0%2B1.21-rc1.jar";
            hash = "sha256-7KjPr2R5A38UOy2XcfXZzH79j4I/YvXgw3lVHw8aOdI=";
          };

          PolyLootr = pkgs.fetchurl {
            url = "https://github.com/unilock/PolyLootr/releases/download/2.0.0%2B1.21%2Bfabric/polylootr-2.0.0+1.21.1+fabric.jar";
            hash = "sha256-3f2D0EjGjNCx9ELMd6U64vryeiAHsznohy9cenhg9FM=";
          };

          # TERRAIN AND WORLD GENERATION

          SkyVillages = pkgs.fetchurl {	  
            url = "https://cdn.modrinth.com/data/mb68eIfx/versions/5Ldpp3lm/SkyVillages-1.0.6-1.21.x-fabric-release.jar";
            hash = "sha256-w5CfFYPmu+hNisnHfzzgTMQA6H8kZR766AbjhRsGug8=";
          };

          Terralith = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/8oi3bsk5/versions/MuJMtPGQ/Terralith_1.21.x_v2.5.8.jar";
            hash = "sha256-ADM6EwrDi3ucqTcACY1eAuBhK9wtNSKq2i825WAGIb8=";
          };

          AmplifiedNether = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/wXiGiyGX/versions/RWIwVls3/Amplified_Nether_1.21.x_v1.2.8.jar";
            hash = "sha256-unKwwJiQCpREvRoFwHzaI95IZuAJWxoCDdWSzGT6Bn8=";
          };

          Nullscape = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/LPjGiSO4/versions/4qC7kfiC/Nullscape_1.21.x_v1.2.11.jar";
            hash = "sha256-UR1UkjGkP8rFSom1DOLruyAdWklaly4IcBZxFX93j7Q=";
          };
        });
      };
    };
  };
}
