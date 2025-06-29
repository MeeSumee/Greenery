# Common NixOS Configuration used by all Hosts
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  flakeOverlays,
  inputs,
  ...
}:{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ja_JP.UTF-8/UTF-8" ] ;
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable essential features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  # bash-fish integration thanks to rexie
  programs.bash = {
    interactiveShellInit = ''
      if [[ ($(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" || -n ''${IN_NIX_SHELL}) && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Extensive fish shell stuff
  programs.fish = {
    enable = true;
    shellAbbrs = {

      # nix stuff
      snwb = "sudo nixos-rebuild boot --flake ~/nixos";
      snwt = "sudo nixos-rebuild test --flake ~/nixos";
      snws = "sudo nixos-rebuild switch --flake ~/nixos";
      nsh = "nix shell nixpkgs#";
      nrn = "nix run nixpkgs#";
      np = "env NIXPKGS_ALLOW_UNFREE=1 nix --impure";

      # git stuff
      ga = "git add --all";
      gc = "git commit";
      gcm = "git commit -m";
      gca = "git commit --amend";
      gcp = "git cherry-pick";
      gd = "git diff";
      gds = "git diff --staged";

      # misc
      # to be added later
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first -1";
      snowboot = "sudo nixos-rebuild boot --flake ~/nixos";
      snowfall = "sudo nixos-rebuild switch --flake ~/nixos";
      snowtest = "sudo nixos-rebuild test --flake ~/nixos";
    };

    interactiveShellInit = let
      lsColors = pkgs.runCommandLocal "lscolors" {nativeBuildInputs = [pkgs.vivid];} ''
        vivid generate rose-pine-moon > $out
      '';
    in ''
      set sponge_purge_only_on_exit true
      set fish_greeting
      set fish_cursor_insert line blink
      set -Ux LS_COLORS $(cat ${lsColors})

      # segsy function to simply open whatever you've typed (in the prompt/) in
      # your $EDITOR so that you can edit there and replace your command line
      # with the edited content (actually sugoi desu rexie-kun)
      function open_in_editor -d "opens current commandline in \$EDITOR"
        set current_command $(commandline)
        set tmp_file $(mktemp --suffix=.fish)
        echo $current_command > $tmp_file
        $EDITOR $tmp_file
        commandline $(cat $tmp_file)
        rm $tmp_file
      end

      function fish_user_key_bindings
        bind --mode insert ctrl-o 'open_in_editor'
        bind ctrl-o 'open_in_editor'
      end

      function fish_mode_prompt;
      end;
    '';
  };

  # Stops building man-cache in nix rebuild
  documentation.man.generateCaches = false;

  # Enable Firmware Updates
  services.fwupd.enable = true;

  # Enable tailscale VPN service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # Enables the use of exit node
  };

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  environment.systemPackages = with pkgs; [
    # Common Applications
    git
    wget
    neovim
    btop
    tree
    unzip
    speedtest-cli
    fzf

    # fish moment
    fishPlugins.done
    fishPlugins.sponge
    eza
    fish-lsp
  ];
}
