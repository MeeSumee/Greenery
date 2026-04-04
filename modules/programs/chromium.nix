{
  config,
  lib,
  pkgs,
  ...
}: let
  # Auto opens links on startup to download
  chromeWebstoreCrxUrl = id: "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${pkgs.ungoogled-chromium.version}&x=id%3D${id}%26uc";

  # Kinda annoying rn cause if version doesn't change, you delete hash file & perform nixos rebuild boot
  deleteFirstRunFiles = ''
    if ! systemctl is-system-running --quiet; then
      echo "system is not fully running yet. skipping chromium update check."
      exit 0
    fi
     echo "checking if chromium hash changed..."
     # configuration hash storage location, might need to be updated to some persistent location on your computer
     CHROMIUM_HASH_FILE="$HOME/chromium-config.hash"
     CURRENT_HASH="${
      builtins.hashString "sha256" (
        (builtins.toJSON config.programs.chromium.extensions)
        + (builtins.toJSON config.programs.chromium.extraOpts.ExtensionSettings)
        + (builtins.toJSON config.programs.chromium.initialPrefs)
      )
    }"
     echo $CURRENT_HASH
     if [ -f "$CHROMIUM_HASH_FILE" ]; then
       STORED_HASH=$(cat "$CHROMIUM_HASH_FILE")
       if [ "$STORED_HASH" = "$CURRENT_HASH" ]; then
         echo "chromium hash unchanged, skipping deletion of 'First Run' files."
         exit 0
       fi
     fi
     echo "chromium hash changed, deleting 'First Run' files..."
     if [ -f "$HOME/.config/chromium/First Run" ]; then
       echo "Deleting '$HOME/.config/chromium/First Run'"
       rm -f "$HOME/.config/chromium/First Run"
     fi
     echo "$CURRENT_HASH" > "$CHROMIUM_HASH_FILE"
  '';

  # ublock policies as an attr set
  ublockPolicies = {
    "defaultFiltering" = "complete";
    "rulesets" = [
      "+adguard-mobile"
      "+block-lan"
      "+dpollock-0"
      "+adguard-spyware-url"
      "+annoyances-ai"
      "+annoyances-cookies"
      "+annoyances-overlays"
      "+annoyances-social"
      "+annoyances-widgets"
      "+annoyances-others"
      "+annoyances-notifications"
      "+ublock-experimental"
      "+ubol-tests"
      "+alb-0"
      "+ara-0"
      "+bgr-0"
      "+chn-0"
      "+cze-0"
      "+deu-0"
      "+fra-0"
      "+grc-0"
      "+hrv-0"
      "+hun-0"
      "+idn-0"
      "+ind-0"
      "+irn-0"
      "+isl-0"
      "+isr-0"
      "+ita-0"
      "+jpn-1"
      "+kor-1"
      "+ltu-0"
      "+lva-0"
      "+mkd-0"
      "+pol-0"
      "+rou-1"
      "+rus-0"
      "+rus-1"
      "+spa-0"
      "+spa-1"
      "+tur-0"
      "+vie-1"
    ];
  };
in {
  options.greenery.programs.chromium.enable = lib.mkEnableOption "Chromium Browsers";

  config = lib.mkIf (config.greenery.programs.chromium.enable && config.greenery.programs.enable) {
    # Credit to https://gist.github.com/MaximilianGaedig/acbce27522c997e9666bd93cef77492d
    programs.chromium = {
      enable = true;

      # Extensions
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBOL
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
        "noimedcjdohhokijigpfcbjcfcaaahej" # Rose-Pine
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "pbanhockgagggenencehbnadejlgchfc" # J*b
      ];

      # DuckDuckGo stuff
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      defaultSearchProviderSuggestURL = "https://ac.duckduckgo.com/ac/?q={searchTerms}&type=list";

      # Policies
      extraOpts = {
        ExtensionSettings =
          # allow added extensions
          (builtins.listToAttrs (
            map
            (ext: {
              name = ext;
              value = {
                installation_mode = "allowed";
              };
            })
            (
              config.programs.chromium.extensions
              ++ [
                "ocaahdebbfolfmndjeplogmgcagdmblk" # chromium web store
              ]
            )
          ))
          // {
            "*" = {
              installation_mode = "blocked"; # Block by default
              blocked_install_message = "Add in chromium.nix";
            };

            # Pin ublock
            "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
              installation_mode = "allowed";
              "toolbar_pin" = "force_pinned";
            };
            # Pin Bitwarden
            "nngceckbapebfimnlniiiahkandclblb" = {
              installation_mode = "allowed";
              "toolbar_pin" = "force_pinned";
            };
            # Pin dark reader
            "eimadpbcbfnmbkopoojfekhnkhdbieeh" = {
              installation_mode = "allowed";
              "toolbar_pin" = "force_pinned";
            };
          };

        # Inherits ublock settings
        "3rdparty" = {
          "extensions" = {
            "ddkjiahejlhfcafbddmgiahcphecmpfh" = ublockPolicies;
          };
        };

        # Shows a page when opening incognito to force enable ublock origin
        "MandatoryExtensionsForIncognitoNavigation" = [
          "ddkjiahejlhfcafbddmgiahcphecmpfh"
        ];

        # Managed bookmarks
        "BookmarkBarEnabled" = true;
        "ManagedBookmarks" = [
          {
            "toplevel_name" = "NixOS Managed Bookmarks";
          }
          {
            "name" = "GitHub - MeeSumee/Greenery";
            "url" = "https://github.com/MeeSumee/Greenery";
          }
          {
            "name" = "NixOS Search";
            "url" = "https://search.nixos.org/";
          }
          {
            "name" = "NixOS Wiki";
            "url" = "https://wiki.nixos.org/wiki/NixOS_Wiki";
          }
          {
            "name" = "Ollama";
            "url" = "quartz.onca-ph.ts.net";
          }
          {
            "name" = "Manga";
            "url" = "manga.onca-ph.ts.net";
          }
          {
            "name" = "Auth";
            "url" = "auth.onca-ph.ts.net";
          }
          {
            "name" = "Jellyfin";
            "url" = "jellyfin.onca-ph.ts.net";
          }
          {
            "name" = "Immich";
            "url" = "immich.onca-ph.ts.net";
          }
          {
            "name" = "FileBrowser";
            "url" = "files.onca-ph.ts.net";
          }
          {
            "name" = "Memos";
            "url" = "memos.onca-ph.ts.net";
          }
        ];

        # 5 = Open New Tab Page
        # 1 = Restore the last session
        # 4 = Open a list of URLs
        # 6 = Open a list of URLs and restore the last session
        "RestoreOnStartup" = 1;

        # 0 = Predict network actions on any network connection
        # 2 = Do not predict network actions on any network connection
        "NetworkPredictionOptions" = 0;

        # Self-explanatory policies
        "HttpsOnlyMode" = "force_enabled";
        "MemorySaverModeSavings" = 1;
        "SearchSuggestEnabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "en-US"
        ];
      };

      # The user has to confirm the installation of extensions on the first run
      initialPrefs = {
        "first_run_tabs" =
          (map chromeWebstoreCrxUrl config.programs.chromium.extensions)
          ++ [
            "https://github.com/NeverDecaf/chromium-web-store/releases/latest/download/Chromium.Web.Store.crx"
          ];
      };
    };

    nixpkgs.overlays = [
      (self: super: {
        ungoogled-chromium = super.ungoogled-chromium.override {
          commandLineArgs = [
            # Theming
            "--enable-incognito-themes"
            "--force-dark-mode"
            # For extension auto-install
            "--extension-mime-request-handling=always-prompt-for-install"
            # Generate Noise to spoof fingerprinting mfs
            "--fingerprinting-canvas-image-data-noise"
            "--fingerprinting-canvas-measuretext-noise"
            "--fingerprinting-client-rects-noise"
            # Fingerprint Protection with console logs to see what's happening, Tab decluttering, User Agent Spoofing & other "fun" stuff
            "--enable-features=WebUIDarkMode,EnableFingerprintingProtectionFilter:activation_level/enabled/enable_console_logging/true,EnableFingerprintingProtectionFilterInIncognito:activation_level/enabled/enable_console_logging/true,TabstripDeclutter,DevToolsPrivacyUI,ImprovedSettingsUIOnDesktop,MultiTabOrganization,OneTimePermission,TabOrganization,TabOrganizationSettingsVisibility,TabReorganization,TabReorganizationDivider,TabSearchPositionSetting,TabstripDedupe,TaskManagerDesktopRefresh,ReduceUserAgentDataLinuxPlatformVersion,ReducedSystemInfo,RemoveClientHints,WebRtcHideLocalIpsWithMdns,SpoofWebGLInfo:renderer/NVIDIA+GeForce+GTX+980%2C+or+similar/vendor/NVIDIA+Corporation"
            # Fuck allowing cast to bind IP
            "--disable-features=CastAllowAllIPs"
            # Wayland Input Method (fcitx5)
            "--enable-wayland-ime=true"
            # GPU/Hardware Acceleration
            "--render-node-override=/dev/dri/renderD128"
            "--enable-gpu-rasterization"
          ];
        };
      })
    ];

    # Hardened systemd script cause I am paranoid
    systemd.user.services.deleteChromiumFirstRun = {
      script = deleteFirstRunFiles;
      wantedBy = ["default.target"];
      serviceConfig = {
        Type = "oneshot";
        ProtectSystem = "full";
        CapabilityBoundingSet = ["CAP_DAC_READ_SEARCH" "CAP_SYSLOG" "CAP_NET_BIND_SERVICE"];
        ProtectClock = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK"];
        SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    # Using machine-based isolation rather than per profile
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
    ];
  };
}
