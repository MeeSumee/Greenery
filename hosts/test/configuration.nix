{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/qemu-vm.nix")
  ];

  greenery = {
    desktop = {
      # enable = true;
      # hypridle.enable = true;
      # hyprland.enable = true;
      # hyprlock.enable = true;
      # niri.enable = true;
      # sddm.enable = true;
      # xserver.enable = true;
    };

    hardware = {
      enable = true;
      # amdgpu.enable = true;
      # audio.enable = true;
      # intelgpu.enable = true;
      # power.enable = true;
    };

    networking = {
      enable = true;
      bluetooth.enable = true;
      dnscrypt.enable = true;
      fail2ban.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };

    programs = {
      enable = true;
      # aagl.enable = true;
      # chromium.enable = true;
      # foot.enable = true;
      # fuzzel.enable = true;
      # micro.enable = true;
      core.enable = true;
      # desktop.enable = true;
      # heavy.enable = true;
      # nvim.enable = true;
      # steam.enable = true;
      # vm.enable = true;
    };

    server = {
      enable = true;
      # anki.enable = true;
      auth.enable = true;
      # davis.enable = true;
      # files.enable = true;
      # home.enable = true;
      # immich.enable = true;
      # jellyfin.enable = true;
      # memos.enable = true;
      # ollama.enable = true;
      # suwayomi.enable = true;
    };

    system = {
      enable = true;
      fish.enable = true;
      # fonts.enable = true;
      # input.enable = true;
      # lanzaboote.enable = true;
      sumee.enable = true;
      # nahida.enable = true;
    };
  };

  # Set virtualization parameters
  virtualisation = {
    memorySize = 4096;
    cores = 4;
    diskSize = 20 * 1024;
    qemu.options = [
      "-bios"
      "${pkgs.OVMF.fd}/FV/OVMF.fd"
    ];
    forwardPorts = [
      {
        from = "host";
        host.port = 16384;
        guest.port = 8000;
      }
    ];
  };

  documentation.enable = false;
  networking.hostName = "nixos";
  system.stateVersion = "25.11";
}
