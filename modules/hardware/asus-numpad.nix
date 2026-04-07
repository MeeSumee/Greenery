{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.asusnumpad.nixosModules.default
  ];
  options.greenery.hardware.asus-numpad.enable = lib.mkEnableOption "Asus Numberpad Driver";

  config = lib.mkIf (config.greenery.hardware.asus-numpad.enable && config.greenery.hardware.enable) {
    # Enable Asus Numpad Service (wayland-1 for niri)
    services.asus-numberpad-driver = {
      enable = true;
      layout = "up5401ea";
      wayland = true;
      waylandDisplay = "wayland-1";
      ignoreWaylandDisplayEnv = false;
      config = {
        "activation_time" = "0.5";
      };
    };
  };
}
