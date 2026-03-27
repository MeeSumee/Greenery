{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greenery.hardware.fprint.enable = lib.mkEnableOption "Fingerprint Module";

  config = lib.mkIf (config.greenery.hardware.fprint.enable && config.greenery.hardware.enable) {
    # Enable Fingerprint Sensor,
    services.fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod.enable = lib.mkDefault true;
      tod.driver = lib.mkDefault pkgs.libfprint-2-tod1-elan; # Elan 04f3:0c6e type fingerprint as default
    };

    # Systemd service
    systemd.services.fprintd = {
      wantedBy = ["multi-user.target"];
      serviceConfig.Type = "simple";
    };
  };
}
