{ 
  config,
  lib, 
  sources, 
  users, 
  pkgs, 
  ...
}:
{

  options.greenery.programs.micro.enable = lib.mkEnableOption "micro";

  config = lib.mkIf (config.greenery.programs.micro.enable && config.greenery.programs.enable) {

    environment.systemPackages = with pkgs; [
      micro
    ];

    # Micro Hjem setup
    hjem.users = lib.genAttrs users (user: {
      files = {
        ".config/micro/plug/lsp".source = sources.micro-plugin-lsp;
        ".config/micro/plug/bounce".source = sources.micro-bounce;
        ".config/micro/plug/quoter".source = sources.micro-quoter;
        ".config/micro/colorschemes".source = ../../dots/micro/colorschemes;
        ".config/micro/bindings.json".source = ../../dots/micro/bindings.json;
        ".config/micro/settings.json".source = ../../dots/micro/settings.json;
      };
    });
  };
}
