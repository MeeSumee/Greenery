{
  config,
  sources,
  lib,
  pkgs,
  users,
  ...
} @ args: let

  inherit (lib) mkEnableOption mkMerge mkIf;
  inherit (lib.modules) importApply;

  argsWith = attrs: args // attrs;
  hjem-lib = import (sources.hjem + "/lib.nix") {
    inherit lib pkgs;
  };
  hjemModule = importApply (sources.hjem + "/modules/nixos") (argsWith {
    inherit hjem-lib;
  });

in {
  imports = [hjemModule];


  # Options maker
  options.greenery.system = {
    sumee.enable = mkEnableOption "Enable the SUMEE user";
    nahida.enable = mkEnableOption "MY WIFE WANTS TO USE MY COMPUTER(s)";
    yang.enable = mkEnableOption "Enable the YANG user";
  };
  
  config = mkMerge [
    
    # Seal hornie rexie in my basement
    ({
      hjem.extraModules = [
        (sources.ecchirexi + "/hjem-impure.nix")
      ];

      hjem.users = lib.genAttrs users (user: {
        impure.enable = true;
      });
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
