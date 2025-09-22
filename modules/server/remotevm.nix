{
  pkgs,
  lib,
  config,
  users,
  ...
}:{
  options.greenery.server.remotevm.enable = lib.mkEnableOption "browser virtual machine";

  config = lib.mkIf (config.greenery.server.remotevm.enable && config.greenery.server.enable) {
    
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
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = true;
                tpmSupport = true;
              }).fd
            ];
          };
        };
        
        # Set libvirtd options declaratively
        # extraOptions = [
        #   "--network bridge=virbr0"
        #   "--graphics vnc,port=5900,listen=127.0.0.1"
        # ];
      };
    };

    # Dependencies
    environment.systemPackages = with pkgs; [
      novnc
      python313Packages.websockify
      OVMF
      qemu
      edk2
      (writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
        -bios ${OVMF.fd}/FV/OVMF.fd \
        "$@"
      '')
    ];

    # noVNC port forwarding
    systemd.services."novnc" = {
      description = "noVNC Service to automatically reverse proxy vnc port to TLS port";
      script = ''
        ${pkgs.novnc}/bin/novnc --listen localhost:6900
      '';
      wantedBy = [ "multi-user.target" ];
      path = lib.mkForce (lib.attrValues {
        inherit (pkgs) ps coreutils gnugrep inetutils;
      });
    };

    # Core networking services
    services = {

      # Tell it to not fuck with port 53 from dnscrypt
      dnsmasq = {
        enable = true;
        settings = {
          listen-address = "127.0.0.1";
          port = 5300;
        };
      };

      # Caddy reverse-proxy using tailscale-caddy plugin
      caddy = {
        enable = true;
        virtualHosts."https://remote.berylline-mine.ts.net" = {
          extraConfig = ''
            root * ${pkgs.novnc}/share/webapps/novnc
            bind tailscale/remote
            reverse_proxy localhost:6900
          '';
        };
      };
    };
  };
}
