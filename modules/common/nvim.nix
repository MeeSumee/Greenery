# It's fucking broken, leaving it for now
{ 
  pkgs,
  inputs, 
  config, 
  lib, 
  options, 
  ... 
}:{
  # Import nvf and hjem
  imports = [
    inputs.nvf.nixosModules.default
    inputs.hjem.nixosModules.default
  ];
  
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
}
