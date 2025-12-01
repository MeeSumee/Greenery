{
  config,
  inputs,
  sources,
  lib,
  pkgs,
  users,
  ...
}: let

  inherit (lib) mkEnableOption mkMerge mkIf;

in {
  imports = [inputs.hjem.nixosModules.default];

  # Options maker
  options.greenery.system = {
    sumee.enable = mkEnableOption "Enable the SUMEE user";
    nahida.enable = mkEnableOption "MY WIFE WANTS TO USE MY COMPUTER(s)";
  };
  
  config = mkMerge [
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
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSVW1+OKXQC3P/x/7SOl6D46BmHPUyFUytFK7G+7kNl 本当に愛してぇる"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3prIWylLFPpuCoNCdKNj3nCqik1lN51CZ73HXhxjvq いやん〜墨ｗｗｗｗ"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmulMynbxFomEUcObvRBp3bVd7kH+dO/6s/0kSBPbbg bedsheetsSoft&Warm"
          ];

          hashedPasswordFile = config.age.secrets.secret6.path;
        };
      };

      # Set face icon for sumee
      systemd.tmpfiles.rules = lib.pipe users [
        (builtins.filter (user: config.hjem.users.${user}.files.".face.icon".source != null))
        (builtins.map (user: [
          "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
          "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${config.hjem.users.${user}.files.".face.icon".source}"
        ]))
        (lib.flatten)
      ];

      # hjem config for sumee
      hjem.users = lib.genAttrs users (user: {
        enable = true;
        directory = config.users.users.${user}.home;
        clobberFiles = lib.mkForce true;
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
          ".config/btop/btop.conf".source = ../../dots/btop/btop.conf;
          ".config/btop/themes".source = sources.rosebtop;
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
  ];
}
