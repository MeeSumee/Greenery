{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nvf.nixosModules.default];

  options.greenery.programs.nvim.enable = lib.mkEnableOption "nvim";

  config = lib.mkIf (config.greenery.programs.nvim.enable && config.greenery.programs.enable) {
    # nvim config
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          options.shiftwidth = 2;
          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
          };
          autopairs.nvim-autopairs.enable = true;
          autocomplete.nvim-cmp.enable = true;
          binds.whichKey.enable = true;
          visuals.indent-blankline.enable = true;
          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions.enable = false;
          };
          languages = {
            enableFormat = true;
            enableDAP = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            bash.enable = true;
            clang.enable = true;
            markdown.enable = true;
            nix = {
              enable = true;
              format.enable = true;
            };
          };
          statusline.lualine = {
            enable = true;
            theme = "auto";
          };
          tabline = {
            nvimBufferline = {
              enable = true;
              mappings = {
                closeCurrent = "<leader>x";
                cycleNext = "<Tab>";
                cyclePrevious = "<S-Tab>";
              };
              setupOpts = {
                options = {
                  indicator.style = "none";
                  show_close_icon = false;
                  show_buffer_close_icons = false;
                  numbers = "none";
                };
              };
            };
          };
          treesitter.enable = true;
          telescope = {
            enable = true;
            mappings = {
              gitBranches = "<leader>gb";
              gitBufferCommits = "<leader>gbc";
              gitCommits = "<leader>gc";
              gitFiles = "<leader>gf";
              gitStash = "<leader>gx";
              gitStatus = "<leader>gs";
            };
          };
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
            transparent = true;
          };
          keymaps = [
            {
              key = "<A-o>";
              mode = "n";
              silent = true;
              lua = true;
              action = ''require("oil").toggle_float'';
            }
          ];
          utility = {
            motion.flash-nvim = {
              enable = true;
              mappings = {
                jump = "<leader>s";
                remote = "<leader>sr";
                toggle = "<A-s>";
                treesitter = "<leader>ss";
                treesitter_search = "<leader>st";
              };
            };
            oil-nvim = {
              enable = true;
              setupOpts = {
                delete_to_trash = true;
                skip_confirm_for_simple_edits = true;
                prompt_save_on_select_new_entry = true;
                use_default_keymaps = false;
              };
            };
          };
        };
      };
    };
  };
}
