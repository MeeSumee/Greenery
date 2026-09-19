{
  config,
  lib,
  pkgs,
  ...
}: let
  # ublock policies as an attr set
  ublockPolicies = {
    "filteringModes" = {
      "complete" = [
        "all-urls"
      ];
    };
    "rulesets" = [
      "+easylist"
      "+easyprivacy"
      "+pgl"
      "+ublock-badware"
      "+ublock-filters"
      "+urlhaus-full"
      "+adguard-mobile"
      "+block-lan"
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
      "+pol-3"
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
        "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx" # uBOL
        "noimedcjdohhokijigpfcbjcfcaaahej;https://clients2.google.com/service/update2/crx" # Rose-Pine
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
            config.programs.chromium.extensions
          ))
          // {
            "*" = {
              installation_mode = "blocked"; # Block by default
              blocked_install_message = "Add in chromium.nix";
            };

            # Pin ublock
            "ddkjiahejlhfcafbddmgiahcphecmpfh" = {
              installation_mode = "allowed";
              toolbar_pin = "force_pinned";
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

        # NO AI SLOP PLEASE
        "AIModeSettings" = 1;
        "BuiltInAIAPIsEnabled" = false;
        "DevToolsGenAiSettings" = 2;
        "GeminiActOnWebSettings" = 1;
        "GeminiSparkSettings" = 1;
        "GenAILocalFoundationalModelSettings" = 1;
        "ThirdPartyAiChatSettings" = 1;

        # Added from chromium hardening guides
        # https://rknf404.github.io/chromium-hardening-guide/
        "AlternateErrorPagesEnabled" = false;
        "AudioSandboxEnabled" = true;
        "AutofillAddressEnabled" = false;
        "AutofillCreditCardEnabled" = false;
        "AutofillPredictionSettings" = 2;
        "AutomatedPasswordChangeSettings" = 2;
        "BackgroundModeEnabled" = false;
        "BlockExternalExtensions" = true;
        "BlockThirdPartyCookies" = true;
        "BrowserLabsEnabled" = false;
        "BrowserSignin" = 0;
        "ChromeSuggestionsSettings" = 1;
        "ChromeVariations" = 2;
        "ClearBrowsingDataOnExitList" = [
          "download_history"
          "cached_images_and_files"
          "autofill"
        ];
        "ClickToCallEnabled" = false;
        "CreateThemesSettings" = 2;
        "DefaultBrowserSettingEnabled" = false;
        "DefaultSensorsSetting" = 2;
        "DesktopSharingHubEnabled" = false;
        "Disable3DAPIs" = true;
        "EnableMediaRouter" = false;
        "ExtensionAllowedTypes" = [
          "extension"
          "theme"
        ];
        "ExtensionDeveloperModeSettings" = 1;
        "ExtensionInstallAllowlist" = [
          "ddkjiahejlhfcafbddmgiahcphecmpfh"
          "noimedcjdohhokijigpfcbjcfcaaahej"
        ];
        "ExtensionInstallBlocklist" = [
          "*"
        ];
        "HelpMeWriteSettings" = 2;
        "HistoryClustersVisible" = false;
        "HistorySearchSettings" = 2;
        "HttpsOnlyMode" = "force_enabled";
        "LiveTranslateEnabled" = false;
        "MediaRecommendationsEnabled" = false;
        "MetricsReportingEnabled" = false;
        "NTPCardsVisible" = false;
        "NativeMessagingBlocklist" = [
          "*"
        ];
        "NetworkPredictionOptions" = 2;
        "NetworkServiceSandboxEnabled" = true;
        "NewTabPageLocation" = "chrome://new-tab-page-third-party";
        "PasswordLeakDetectionEnabled" = false;
        "PasswordManagerEnabled" = false;
        "PaymentMethodQueryEnabled" = false;
        "PrivacySandboxAdMeasurementEnabled" = false;
        "PrivacySandboxAdTopicsEnabled" = false;
        "PrivacySandboxPromptEnabled" = false;
        "PrivacySandboxSiteEnabledAdsEnabled" = false;
        "PromotionsEnabled" = false;
        "PromptForDownloadLocation" = true;
        "RelatedWebsiteSetsEnabled" = false;
        "RemoteAccessHostAllowRemoteAccessConnections" = false;
        "RemoteAccessHostFirewallTraversal" = false;
        "RemoteDebuggingAllowed" = false;
        "SafeBrowsingDeepScanningEnabled" = false;
        "SafeBrowsingExtendedReportingEnabled" = false;
        "SafeBrowsingSurveysEnabled" = false;
        "SearchContentSharingSettings" = 1;
        "SearchSuggestEnabled" = false;
        "SharedClipboardEnabled" = false;
        "ShoppingListEnabled" = false;
        "ShowFullUrlsInAddressBar" = true;
        "SitePerProcess" = true;
        "SpellCheckServiceEnabled" = false;
        "SyncDisabled" = true;
        "TabCompareSettings" = 2;
        "TranslateEnabled" = false;
        "TranslatorAPIAllowed" = false;
        "UrlKeyedAnonymizedDataCollectionEnabled" = false;
        "UserFeedbackAllowed" = false;
        "VoiceTypingSettings" = 2;
        "WebRtcIPHandling" = "disable_non_proxied_udp";
        "WebRtcTextLogCollectionAllowed" = false;

        # 5 = Open New Tab Page
        # 1 = Restore the last session
        # 4 = Open a list of URLs
        # 6 = Open a list of URLs and restore the last session
        "RestoreOnStartup" = 1;
      };
    };

    nixpkgs.overlays = [
      (self: super: {
        chromium = super.chromium.override {
          commandLineArgs = [
            # Theming
            "--force-dark-mode"
            "--use-fake-device-for-media-stream"
            "--component-updater=disable-pings"
            "--disable-breakpad"
            "--disable-crash-reporter"
            "--no-default-browser-check"
            "--disable-remote-fonts"
            "--no-pings"
            "--propagate-iph-for-testing"
            "--js-flags=--jitless"
            "--disable-webgl"
            "--disable-3d-apis"
            "--extension-content-verification=enforce_strict"
            "--extensions-install-verification=enforce_strict"
            "--enable-features=ClearCrossSiteCrossBrowsingContextGroupWindowName,CertificateTransparencyAskBeforeEnabling,IsolateSandboxedIframes:grouping/per-document,AllowWithholdingExtensionPermissionsOnInstall,DebuggerAPIRestrictedToDevMode,SearchEngineUnconditionalDialog,LocalNetworkAccessChecksWebRTC,PartitionAllocWithAdvancedChecks:enabled-processes/all-processes,OriginKeyedProcessesByDefault,HstsTopLevelNavigationsOnly,PartitionConnectionsByNetworkIsolationKey,ScopeMemoryCachePerContext,SplitCacheByIncludeCredentials,SplitCacheByNetworkIsolationKey,SplitCodeCacheByNetworkIsolationKey,ReduceAcceptLanguage,StrictOriginIsolation"
            "--disable-features=AimEnabled,LensStandalone,StarterPackExpansion,AutofillServerCommunication,InterestFeedV2,NTPPopularSitesBakedInContent,Journeys,MediaDrmPreprovisioning,OptimizationHints,OptimizationHintsFetchingSRP,BrowsingTopics,BrowsingTopicsDocumentAPI,BrowsingTopicsParameters,PrivacySandboxSettings4,Reporting,CrashReporting,DocumentReporting,AllowSwiftShaderFallback,AllowSoftwareGLFallbackDueToCrash,TabHoverCardImages,WebGPUBlobCache,WebGPUService"
          ];
        };
      })
    ];
    environment.systemPackages = with pkgs; [
      chromium
    ];
  };
}
