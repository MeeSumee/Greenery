{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greenery.hardware.tpm.enable = lib.mkEnableOption "TPM Security";

  config = lib.mkIf (config.greenery.hardware.tpm.enable && config.greenery.hardware.enable) {
    # Enable TPM module
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    # Systemd script to delay tpm start to eliminate 256 error spam
    # adapted from https://gist.github.com/guilhem/d372e8a257d5f67678ea33c662c48f39
    systemd.services.tpm-startup = {
      description = "Execute TPM2 Startup with Delay After Suspend";
      after = [
        "systemd-suspend.service"
        "systemd-hybrid-sleep.service"
        "systemd-hibernate.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
        ExecStart = "${pkgs.tpm2-tools}/bin/tpm2_startup";
      };
      wantedBy = [
        "sleep.target"
        "multi-user.target"
      ];
    };
  };
}
