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
          syntaxHighlighting = true;
          viAlias = true;
          vimAlias = true;
          autopairs.nvim-autopairs.enable = true;
          autocomplete.nvim-cmp.enable = true;
          binds.whichKey.enable = true;
          git.enable = true;
          options.shiftwidth = 2;
          treesitter.enable = true;
          undoFile.enable = true;
          visuals.indent-blankline.enable = true;

          diagnostics = {
            enable = true;
            config.virtual_lines = true;
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

          lsp = {
            enable = true;
            formatOnSave = true;
            lightbulb.enable = true;
            trouble.enable = true;
          };

          languages = {
            enableFormat = true;
            enableDAP = true;
            enableTreesitter = true;
            enableExtraDiagnostics = true;
            bash.enable = true;
            clang.enable = true;
            go.enable = true;
            json.enable = true;
            lua.enable = true;
            markdown.enable = true;
            nix.enable = true;
            python.enable = true;
            yaml.enable = true;
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
                  diagnostics = false;
                  indicator.style = "none";
                  show_close_icon = false;
                  show_buffer_close_icons = false;
                  numbers = "none";
                };
              };
            };
          };

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

          utility = {
            oil-nvim = {
              enable = true;
              gitStatus.enable = true;
              setupOpts = {
                delete_to_trash = true;
                skip_confirm_for_simple_edits = true;
                prompt_save_on_select_new_entry = true;
                use_default_keymaps = false;
                keymaps = {
                  "?" = lib.mkLuaInline ''{ require("oil.actions").show_help, mode = "n" }'';
                  "<Enter>" = lib.mkLuaInline ''{ require("oil.actions").select, mode = { "n", "v" } }'';
                  "<BS>" = lib.mkLuaInline ''{ require("oil.actions").parent, mode = "n" }'';
                  "." = lib.mkLuaInline ''require("oil.actions").toggle_hidden'';
                  "t" = lib.mkLuaInline ''require("oil.actions").toggle_trash'';
                  "q" = lib.mkLuaInline ''require("oil.actions").close'';
                  "<Tab>" = lib.mkLuaInline ''require("oil.actions").open_cwd'';
                  "`" = lib.mkLuaInline ''require("oil.actions").cd'';
                  "<S-Enter>" = lib.mkLuaInline ''{ require("oil.actions").open_external, mode = "n" }'';
                };
              };
            };
          };
        };
      };
    };
  };
}
