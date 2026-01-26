{ 
  config, 
  lib, 
  pkgs,
  ...
}: {

  options.greenery.programs.vm.enable = lib.mkEnableOption "libvirtd for VM";

  config = lib.mkIf (config.greenery.programs.vm.enable && config.greenery.programs.enable) {

    # Add users to libvirtd group
    users.users.sumee.extraGroups = [ "libvirtd" ];

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

    # This might fucking work
    networking = {
      firewall.trustedInterfaces = [ "virbr0" ];
    };

    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
