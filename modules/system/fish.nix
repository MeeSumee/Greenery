{
  pkgs,
  lib,
  config,
  users,
  sources,
  ...
}:

let
  inherit (config.networking) hostName;
  rebuildCommand = "sudo nixos-rebuild --log-format bar --no-reexec --file ~/green/default.nix -A ${hostName}";

in {

  options.greenery.system.fish.enable = lib.mkEnableOption "fish shell";

  config = lib.mkIf (config.greenery.system.fish.enable && config.greenery.system.enable) {

    # Enables users to use the shell
    users.users = lib.genAttrs (users ++ ["root"])
    (
      usershell: {
        shell = pkgs.fish;
      }
    );

    # man-cache is too annoying
    documentation.man.generateCaches = false;

    # Extensive fish shell stuff
    programs.fish = {
      enable = true;

      # Removes bash script reliance for nix startups
      useBabelfish = true;

      # Abbreviations to expand commands with simple keywords
      shellAbbrs = {

        # nix stuff
        snr = rebuildCommand;
        nsh = "nix shell nixpkgs#";
        nrn = "nix run nixpkgs#";
        nbn = "nix build nixpkgs#";

        # git stuff
        gaa = "git add --all";
        ga = "git add";
        gs = "git status";
        gc = "git commit";
        gcm = "git commit -m";
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
        qsp = "qs -p ~/green/quickshell/";
        n = "nvim";
      };

      # Aliases to execute commands directly
      shellAliases = {
        ls = "eza --icons --group-directories-first -1";
        gparted = "sudo -EH gparted";
        snowball = "${rebuildCommand} boot";
        snowfall = "${rebuildCommand} switch";
        snowstorm = "${rebuildCommand} test";
        snowshed = "${rebuildCommand} dry-build";
        schizo = "ssh administrator@greenery";
        escape = "ssh sumee@kaolin";
      };

      # Coloring shell, referenced from Zaphkiel config
      interactiveShellInit = let
        lsColors = pkgs.runCommandLocal "lscolors" {nativeBuildInputs = [pkgs.vivid];} ''
          vivid generate dracula > $out
        '';
        dracula-fzf = ["fg:#f8f8f2" "bg:#282a36" "hl:#bd93f9" "fg+:#f8f8f2" "bg+:#44475a" "hl+:#bd93f9" "info:#ffb86c" "prompt:#50fa7b" "pointer:#ff79c6" "marker:#ff79c6" "spinner:#ffb86c" "header:#6272a4"];
        fzf-options = builtins.concatStringsSep " " (builtins.map (option: "--color=" + option) dracula-fzf);
      in ''
        set sponge_purge_only_on_exit true
        set fish_greeting
        set fish_cursor_insert line blink
        set -Ux LS_COLORS $(cat ${lsColors})
        set -Ux FZF_DEFAULT_OPTS ${fzf-options}

        function fish_user_key_bindings
          bind --mode insert alt-c 'cdi; commandline -f repaint'
          bind --mode insert alt-f 'fzf-file-widget'
        end

        # hydro (prompt) stuff
        set -g hydro_symbol_start
        set -U hydro_symbol_git_dirty "*"
        set -U fish_prompt_pwd_dir_length 0
        function fish_mode_prompt; end;
        function update_nshell_indicator --on-variable IN_NIX_SHELL
          if test -n "$IN_NIX_SHELL";
            set -g hydro_symbol_start "impure "
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
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    # Fish integration
    programs.direnv.enableFishIntegration = true;

    # CNF
    programs.command-not-found.enable = false;

    # Fuzzy Finder keybinds
    programs.fzf.keybindings = true;

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
        ".config/fish/config.fish".source = ../../dots/fish/config.fish;
        ".config/fish/themes".source = sources.dracula-fish + "/themes";        
      };
    });    
  };
}
