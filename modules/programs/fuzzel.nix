{
  users,
  config,
  lib,
  pkgs,
  sources,
  ...
}: {
  options.greenery.desktop.fuzzel.enable = lib.mkEnableOption "fuzzel";

  config = lib.mkIf (config.greenery.desktop.fuzzel.enable && config.greenery.desktop.enable) {
    environment.systemPackages = [pkgs.fuzzel];

    # Set fuzzel dot file
    hjem.users = lib.genAttrs users (user: {
      files = {
        ".config/fuzzel/fuzzel.ini" = {
          generator = lib.generators.toINIWithGlobalSection {};
          value = {
            globalSection = {
              dpi-aware = "auto";
              icon-theme = "Papirus-Dark";
              font = "Hack:weight=bold:size=18";
              fields = "name,generic,comment,categories,filename,keywords";
              password-character = "*";
              terminal = "foot -e";
              prompt = ''"❯ "'';
              show-actions = "yes";
              exit-on-keyboard-focus-loss = "no";
              include = "${sources.catfuzzel + "/themes/catppuccin-mocha/blue.ini"}";
              lines = 15;
              width = 30;
              horizontal-pad = 40;
              vertical-pad = 8;
              inner-pad = 0;
            };
          };
        };
      };
    });
  };
}
