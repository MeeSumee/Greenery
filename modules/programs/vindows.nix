{ 
  config, 
  lib, 
  pkgs,
  users,
  ...
}: {

  options.greenery.programs.vindows.enable = lib.mkEnableOption "Virtual Machine Windows";

  config = lib.mkIf (config.greenery.programs.vindows.enable && config.greenery.programs.enable) {

    # Add users to libvirtd group
    users.extraUsers = lib.genAttrs users (user: {  
      extraGroups = [ "libvirtd" ];
    });

    # Enable virt-man
    programs.virt-manager.enable = true;
    
    # Virtualisation Config
    virtualisation = {
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
    };

    # Tell it to not fuck with port 53 from dnscrypt
    services = {
      dnsmasq = {
        enable = true;
        settings = {
          listen-address = "127.0.0.1";
          port = 5300;
        };
      };
    };
  };
}
