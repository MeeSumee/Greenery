# It's fucking broken, leaving it for now
{ 
  pkgs,
  inputs,
  sources, 
  config, 
  lib, 
  options, 
  ... 
}:{

  # Import nvf and hjem
  imports = [
    inputs.nvf.nixosModules.default
    (sources.hjem + "/modules/nixos")
  ];

  options.greenery.programs.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
  
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            name = "gruvbox";
            style = "dark";
          };

          lsp = {
            enable = true;
          };

          languages = {
            enableTreesitter = true;
            nix.enable = true;
          };

          statusline.lualine.enable = true;
          telescope.enable = true;
          autocomplete.nvim-cmp.enable = true;

          extraPlugins = with pkgs.vimPlugins; {
            LazyVim = {
              package = LazyVim;

              setup = ''
                require("lazy").setup({
                  defaults = {
                    lazy = true,
                  },
                })
              '';
            };
          };
        };
      };
    };
  };
}
