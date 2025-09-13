{
  config,
  inputs,
  lib,
  pkgs,
  users,
  ...
}: let

  inherit (lib) mkEnableOption mkMerge mkIf;

  nix-dir = "green";

  points = let
    inherit (lib.fileset) unions toSource;
    root = ../../dots;
  in
    toSource {
      inherit root;
      fileset = unions [
        (root + /fish/config.fish)
        (root + /foot/foot.ini)
        (root + /fuzzel/fuzzel.ini)
        (root + /hyprland/hypridle.conf)
        (root + /hyprland/hyprland.conf)
        (root + /hyprland/hyprlock.conf)
        (root + /niri/config.kdl)
        (root + /uwsm/env)
      ];
    };

in {
  imports = [inputs.hjem.nixosModules.default];

  # Options maker
  options.greenery.system = {
    sumee.enable = mkEnableOption "Enable the SUMEE user";
    nahida.enable = mkEnableOption "MY WIFE WANTS TO USE MY COMPUTER(s)";
    yang.enable = mkEnableOption "Enable the YANG user";
  };
  
  config = mkMerge [
    
    # Seal hornie rexie in my basement
    ({
      hjem.extraModules = [inputs.ecchirexi.hjemModules.default];
      
      # Hjem config for all users
      hjem.users = lib.genAttrs users (user: {
        enable = true;
        directory = config.users.users.${user}.home;
        clobberFiles = lib.mkForce true;
      });

      # Set face icon for all users
      systemd.tmpfiles.rules = lib.pipe users [
        (builtins.filter (user: config.hjem.users.${user}.files.".face.icon".source != null))
        (builtins.map (user: [
          "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
          "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${config.hjem.users.${user}.files.".face.icon".source}"
        ]))
        (lib.flatten)
      ];
    })

    # WHERE DOES THE STOMEE LIVE???
    (mkIf (config.greenery.system.sumee.enable && config.greenery.system.enable) {
      
      age.secrets.secret6 = {
        file = ../../secrets/secret6.age;
        owner = "sumee";
      };

      users.users = {
        sumee = {
          isNormalUser = true;
          description = "Sumee";
          extraGroups = ["networkmanager" "wheel" "fuse"];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITLg3/cEFB883XDG1KnaSmEAkYbqOBJMziWmfEadqO ナヒーダの白い髪"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwTjZGFn9J8wwwSAxfIirryeMBBLofBNF7fZ40engRh はとっても可愛いですよ"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIX4OMIF84eVKP5JqtAoE0/Wqd8c8cY2gAsXsKPC8C+X 本当に愛してぇる"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSVW1+OKXQC3P/x/7SOl6D46BmHPUyFUytFK7G+7kNl `もうやめろすみちゃん〜〜`"
          ];

          hashedPasswordFile = config.age.secrets.secret6.path;
        };
      };

      # hjem config for all sumee users
      hjem.users = lib.genAttrs users (user: {

        # Yoinked from rexies.nix
        impure = {
          enable = true;
          dotsDir = "${points}";
          dotsDirImpure = "/home/${user}/${nix-dir}/dots";
          parseAttrs = [config.hjem.users.${user}.xdg.config.files];
        };

        xdg.config.files = let
          dots = config.hjem.users.${user}.impure.dotsDir;
        in {
          # Fish shell
          "fish/config.fish".source = dots + "/fish/config.fish";
          
          # Foot terminal
          "foot/foot.ini".source = dots + "/foot/foot.ini";

          # Fuzzel
          "fuzzel/fuzzel.ini".source = dots + "/fuzzel/fuzzel.ini";

          # Hyprland stuff
          "hypr/hypridle.conf".source = dots + "/hyprland/hypridle.conf";
          "hypr/hyprland.conf".source = dots + "/hyprland/hyprland.conf";
          "hypr/hyprlock.conf".source = dots + "/hyprland/hyprlock.conf";
          "uwsm/env".source = dots + "/uwsm/env";

          # Niri stuff
          "niri/config.kdl".source = dots + "/niri/config.kdl";
        };

        files = let 
          # Make face.icon at /home/user/
          faceIcon = let
            pfp = pkgs.fetchurl {
              name = "vivianpfp.jpg";
              url = "https://cdn.donmai.us/original/b3/b2/__vivian_banshee_zenless_zone_zero_drawn_by_icetea_art__b3b237c829304f29705f1291118e468f.jpg?download=1";
              hash = "sha256-KQZHp4tOufAOI4utGo8zLpihicMTzF5dRzQPEKc4omI=";
            };
          in
            pkgs.runCommandWith {
              name = "cropped-${pfp.name}";
              derivationArgs.nativeBuildInputs = [pkgs.imagemagick];
            } ''
              magick ${pfp} -crop 1000x1000+210+100 - > $out
            '';

        in {
          ".face.icon".source = faceIcon;
        };
      });
    })
    
    # SHE'S MAKING A SUPERCOMPUTER IN MINECRAFT AGAIN????
    (mkIf (config.greenery.system.nahida.enable && config.greenery.system.enable) {
      
      users.users = {
        nahida = {
          isNormalUser = true;
          description = "Nahida";
          extraGroups = ["networkmanager" "wheel"];
        };
      };
    })

    # 陽ーおじさん wants to use a computer to learn linux sex
    (mkIf (config.greenery.system.yang.enable && config.greenery.system.enable) {

      users.users = {
        yang = {
          isNormalUser = true;
          description = "Yang";
          extraGroups = ["networkmanager" "wheel"];
        };
      };
    })
  ];
}
