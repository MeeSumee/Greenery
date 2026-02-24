{
  pkgs,
  lib,
  config,
  users,
  sources,
  ...
}: let
  rebuildCommand = "nixos-rebuild --flake ~/green# -S";
in {
  options.greenery.system.fish.enable = lib.mkEnableOption "fish shell";

  config = lib.mkIf (config.greenery.system.fish.enable && config.greenery.system.enable) {
    # Enables users to use the shell
    users.users =
      lib.genAttrs (users ++ ["root"])
      (
        usershell: {
          shell = pkgs.fish;
        }
      );

    # man-cache is too annoying
    documentation.man.generateCaches = false;
    programs = {
      # Extensive fish shell stuff
      fish = {
        enable = true;

        # Removes bash script reliance for nix startups
        useBabelfish = true;

        # Abbreviations to expand commands with simple keywords
        shellAbbrs = {
          # nix stuff
          nrb = rebuildCommand;
          ns = "nix shell nixpkgs#";
          nr = "nix run nixpkgs#";
          nb = "nix build nixpkgs#";

          # git stuff
          gaa = "git add --all";
          ga = "git add";
          gs = "git status";
          gc = "git commit";
          gcm = ''git commit -m "$hostname:'';
          gck = "git checkout -b";
          gp = "git push";
          gpu = "git pull";
          gsw = "git switch";
          gca = "git commit --amend";
          gcp = "git cherry-pick";
          grsa = "git restore --staged .";
          grs = "git restore --staged";
          gr = "git restore";
          gra = "git restore .";
          gd = "git diff";
          gds = "git diff --staged";
          gl = "git log";

          # misc
          n = "nvim";
        };

        # Aliases to execute commands directly
        shellAliases = {
          ls = "eza --icons --group-directories-first -1";
          lt = "eza -l -a --icons --group-directories-first -T";
          snowball = "${rebuildCommand} boot";
          snowfall = "${rebuildCommand} switch";
          snowstorm = "${rebuildCommand} test";
          snowshed = "${rebuildCommand} dry-build";
          schizo = "ssh sumee@greenery";
          libre = "ssh sumee@kaolin";
          deployin = "${rebuildCommand} --use-substitutes --target-host sumee@kaolin boot";
          deployer = "${rebuildCommand} --build-host sumee@verdure --target-host sumee@verdure boot";
        };

        # Coloring shell, referenced from Zaphkiel config
        interactiveShellInit = let
          rosepine-fzf = [
            "fg:#908caa"
            "bg:-1"
            "hl:#ebbcba"
            "fg+:#e0def4"
            "bg+:#26233a"
            "hl+:#ebbcba"
            "border:#403d52"
            "header:#31748f"
            "gutter:#191724"
            "spinner:#f6c177"
            "info:#9ccfd8"
            "pointer:#c4a7e7"
            "marker:#eb6f92"
            "prompt:#908caa"
          ];
          fzf-options = builtins.concatStringsSep " " (builtins.map (option: "--color=" + option) rosepine-fzf);
        in ''
          set sponge_purge_only_on_exit true
          set fish_greeting
          set fish_cursor_insert line blink
          set -Ux LS_COLORS (${pkgs.vivid}/bin/vivid generate rose-pine)
          set -Ux FZF_DEFAULT_OPTS ${fzf-options}

          # Set real-time config
          fish_config theme choose "Rosé Pine"
          set -U hydro_color_pwd $fish_color_pine
          set -U hydro_color_git $fish_color_foam
          set -U hydro_color_start $fish_color_iris
          set -U hydro_color_error $fish_color_love
          set -U hydro_color_prompt $fish_color_pine
          set -U hydro_color_duration $fish_color_iris
          set -U fish_prompt_pwd_dir_length 0
          set -g fish_color_search_match
          set -g fish_pager_color_background
          set -g fish_pager_color_selected_background

          function fish_user_key_bindings
            bind --mode insert alt-c 'cdi; commandline -f repaint'
            bind --mode insert alt-f 'fzf-file-widget'
          end

          # hydro (prompt) stuff
          set -g hydro_symbol_start
          set -U hydro_symbol_git_dirty "*"
          set -U fish_prompt_pwd_dir_length 0
          function fish_mode_prompt; end;

          # Sets package in nix shell prompt
          set in_nix_shell "$(echo $PATH | awk '{i=1; while($i ~ /store/){ if($i !~ /(-man|-doc)\//){print $i} i++ }}' | cut -d'-' -f2- | rev | cut -d'-' -f2- | rev | tr '\n' ' ')"
          function update_nshell_indicator --on-variable in_nix_shell
            if test -n "$in_nix_shell";
              set -g hydro_symbol_start "$in_nix_shell"
            else
              set -g hydro_symbol_start
            end
          end
          update_nshell_indicator

          # smoll script to get the store path given an executable name
          function store_path -a package_name
            which $package_name 2> /dev/null | path resolve | read -l package_path
            if test -n "$package_path"
              echo (path dirname $package_path | path dirname)
            end
          end
        '';
      };

      # Zoxide, faster change directory
      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      # Fish integration
      direnv.enableFishIntegration = true;

      # CNF
      command-not-found.enable = false;

      # Fuzzy Finder keybinds
      fzf.keybindings = true;
    };

    # Fish dependancies
    environment.systemPackages = with pkgs; [
      fishPlugins.done
      fishPlugins.sponge
      fishPlugins.hydro
      eza
      fish-lsp
      babelfish
    ];

    # Hjem fish dotfiles
    hjem.users = lib.genAttrs users (user: {
      files = {
        ".config/fish/themes".source = sources.rosefish + "/themes";
      };
    });
  };
}
