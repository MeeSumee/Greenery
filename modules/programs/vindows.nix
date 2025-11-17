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

    # Provide UEFI firmware support to virt-manager (due to depreciated OVMF module)
    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

    # Enable dnsmasq for NAT routing
    services = {
      dnsmasq = {
        enable = true;
      };
    };
  };
}
