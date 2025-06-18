# Start of Config
{
  config,
  pkgs,
  options,
  lib,
  modulesPath,
  flakeOverlays,
  inputs,
  ...
}: {
  imports = [
    # Imports.
    ./aagl.nix
    ./desktop.nix
    ./inputfont.nix
  ];
  
  # Nix Overlays defined from flake.nix
  nixpkgs.overlays = [ inputs.nix-matlab.overlay ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beryl"; # The tint of blue I like
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Set internationalisation properties.
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define user accounts.
  users.users = {
    sumeezome = {
      isNormalUser = true;
      description = "Sumeezome";
      extraGroups = ["networkmanager" "wheel"];
    };
  };
  
  # Firefox
  programs.firefox.enable = false;
  
  # Gaseous H2O
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; #Firewall port for steam remote play
    dedicatedServer.openFirewall = true; #Firewall port for dedicated server
    localNetworkGameTransfers.openFirewall = true; #Firewall port for local network game transfers
    gamescopeSession.enable = true;
  };
  
  # Java
  programs.java.enable = true;
  
  # Extensive fish shell stuff (I cast thy spell STEAL on github:Rexcrazy804/Zaphkiel)
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
      fish_vi_key_bindings

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
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.direnv.enableFishIntegration = true;

  programs.command-not-found.enable = false;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Desktop Programs
    matlab # Matlab for control systems and processing, WIP
    matlab-shell # Matlab-shell for installing MATLAB
    (pkgs.discord.override { enableAutoscroll = true; }) # Discord + Auto Scroll Option
    librewolf # Librewolf browser
    brave # Import Browser Profiles
    neovim # neovim text editor
    vscodium # VSCodium text editor
    fzf # Fuzzy Finder
    foot # foot terminal
    btop # System Monitor
    sbctl # Secure Boot Control
    git # Self-explanatory
    openshot-qt # Video Editing
    gimp3 # Image Manipulation
    foliate # e-book reader
    wineWowPackages.waylandFull # Wine
    xournalpp # Note taking
    vlc # Media Player
    libreoffice-fresh # MSOffice Alternative
    gparted # Disk Partitioning
    prismlauncher # Minecraft
    zoom-us # Meetings
    arduino-ide # Programming

    # Flake Packages
    (pkgs.callPackage ../../pkgs/cursors.nix {})

    # Niri stuff
    fuzzel # Get shit up and running cause I cannot do anything lmao

    # Gnome stuff
    gnome-tweaks # Nahida Cursors & Other Cool Stuff >.<
    papirus-icon-theme # Icon Theme
    gnomeExtensions.kimpanel # Input Method Panel
    gnomeExtensions.blur-my-shell # Blurring Appearance Tool
    gnomeExtensions.user-themes

    # fish moment
    fishPlugins.done
    fishPlugins.sponge
    eza
    fish-lsp
  ];

  # Adds rocm support to btop and nixos
  nixpkgs.config.rocmSupport = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
/*
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
*/
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = ["Sumeezome"];
    };
  };
  
  # Enable tailscale VPN service
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # Enables the use of exit node
  };
  
  # Fix tailscale auto-connect during login (might not be necessary)
  systemd.services.tailscaled-autoconnect.serviceConfig.Type = lib.mkForce "exec";
  
  # Fix Gnome Keyring popup when using certain applications (Brave in my case)
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Enable Firmware Updates
  services.fwupd.enable = true;
  
  # Open ports in the firewall.
/*  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1716 ]; # Port 1716 for KDEConnect, but I can just use tailscale lmao
    allowedUDPPorts = [ 1716 ];
  };
*/
/*
  This value determines the NixOS release from which the default
  settings for stateful data, like file locations and database versions
  on your system were taken. It‘s perfectly fine and recommended to leave
  this value at the release version of the first install of this system.
  Before changing this value read the documentation for this option
  (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
*/
  system.stateVersion = "24.11"; # Did you read the comment?
}
