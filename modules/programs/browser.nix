{
  config,
  lib,
  pkgs,
  ...
}:{

  options.greenery.programs.browser.enable = lib.mkEnableOption "brave and librewolf";

  config = lib.mkIf (config.greenery.programs.browser.enable && config.greenery.programs.enable) {

    # Librewolf Browser
    programs.firefox = {
      enable = true;
      package = pkgs.librewolf;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        SanitizeOnShutdown = false;
        Preferences = {
          "browser.contentblocking.category" = "strict";
          "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
          "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;
          "network.cookie.cookieBehavior.optInPartitioning" = true;
          "network.cookie.CHIPS.enabled" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = false;
          "privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3" = true;
          "browser.cache.disk.enable" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "media.memory_cache_max_size" = 65536;
          "browser.shell.shortcutFavicons" = false; 
          "browser.helperApps.deleteTempFileOnExit" = true;
          "privacy.history.custom" = true;
          "browser.privatebrowsing.autostart" = false;
          "browser.formfill.enable" = false;
          "browser.sessionstore.privacy_level" = 2;
          "privacy.query_stripping.strip_list" = ''
            __hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid 
            ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk 
            oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid
          '';
          
          "browser.dom.window.dump.enabled" = false;
          "devtools.console.stdout.chrome" = false;
          "dom.security.https_only_mode" = true;
          "network.auth.subresource-http-auth-allow" = 1;

          "network.http.referer.XOriginTrimmingPolicy" = 2;
          
          "media.peerconnection.ice.default_address_only" = true;

          "network.gio.supported-protocols" = "";
          "network.file.disable_unc_paths" = true;
          "network.proxy.socks_remote_dns" = true;
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

          "network.dns.disablePrefetch" = true;

          "doh-rollout.provider-list" = [
            {
              "UIName" = "Quad9 (No Filtering)";
              "uri" = "https://dns10.quad9.net/dns-query";
            }
            {
              "UIName" = "Quad9 (Malware blocking)";
              "uri" = "https://dns.quad9.net/dns-query";
            }
            {
              "UIName" = "LibreDNS (No Filtering)";
              "uri" = "https://doh.libredns.gr/dns-query";
            }
            {
              "UIName" = "LibreDNS (Adblocking)";
              "uri" = "https://doh.libredns.gr/noads";
            }
            {
              "UIName" = "Wikimedia DNS (No Filtering)";
              "uri" = "https://wikimedia-dns.org/dns-query";
            }
            {
              "UIName" = "DNS4All (No Filtering)";
              "uri" = "https://doh.dns4all.eu/dns-query";
            }
            {
              "UIName" = "Mullvad (No Filtering)";
              "uri" = "https://dns.mullvad.net/dns-query";
            }
          ];

          "network.trr.mode" = 5;
          "network.trr.uri" = "https://dns10.quad9.net/dns-query";

          "network.trr.strict_native_fallback" = false;
          "network.trr.retry_on_recoverable_errors" = true;
          "network.trr.disable-heuristics" = true;
          "network.trr.default_provider_uri" = "https://doh.dns4all.eu/dns-query";
          "network.trr.allow-rfc1918" = true;

          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;
          "network.http.speculative-parallel-limit" = 0;
          "browser.places.speculativeConnect.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "browser.display.use_system_colors" = false;
          "privacy.window.maxInnerWidth" = 1600;
          "privacy.window.maxInnerHeight" = 900;
          "privacy.resistFingerprinting.letterboxing" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.globalprivacycontrol.pbmode.enabled" = true;
          "privacy.globalprivacycontrol.functionality.enabled" = true;

          "webgl.disabled" = false;
          "dom.webgpu.enabled" = false;

          "security.cert_pinning.enforcement_level" = 2;
          "security.ssl.require_safe_negotiation" = true;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.pki.crlite_mode" = 2;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.OCSP.require" = true;

          "security.tls.enable_0rtt_data" = false;
          "security.tls.version.enable-deprecated" = false;
          "browser.xul.error_pages.expert_bad_cert" = true;

          "permissions.manager.defaultsUrl" = "";

          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.provider.google4.gethashURL" = "";
          "browser.safebrowsing.provider.google4.updateURL" = "";
          "browser.safebrowsing.provider.google.gethashURL" = "";
          "browser.safebrowsing.provider.google.updateURL" = "";
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.provider.google4.dataSharingURL" = "";

          "network.IDN_show_punycode" = true;
          "pdfjs.enableScripting" = false;

          "geo.provider.network.url" = "https://api.beacondb.net/v1/geolocate";
          "geo.provider.use_gpsd" = false;
          "geo.provider.use_geoclue" = false;

          "browser.region.network.url" = "";
          "browser.region.update.enabled" = false;

          "media.eme.enabled" = true;
          "media.gmp-manager.url" = "data:text/plain,";
          "media.gmp-provider.enabled" = false;
          "media.gmp-gmpopenh264.enabled" = false;
          "media.webrtc.hw.h264.enabled" = true;

          "browser.urlbar.suggest.searches" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.update" = false;
          "browser.search.separatePrivateDefault" = false;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.serpEventTelemetryCategorization.enabled" = false;
          "browser.urlbar.suggest.mdn" = true;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.mdn.featureGate" = false;
          "browser.urlbar.trending.featureGate" = false;
          "browser.urlbar.weather.featureGate" = false;
          "browser.download.start_downloads_in_tmp_dir" = true;

          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.suggest.weather" = false;

          "browser.urlbar.update2.engineAliasRefresh" = true;

          "browser.download.useDownloadDir" = false;
          "browser.download.autohideButton" = false;
          "browser.download.manager.addToRecentDocs" = false;
          "browser.download.alwaysOpenPanel" = false;

          "media.autoplay.default" = 5;

          "dom.disable_window_move_resize" = true;
          "browser.link.open_newwindow" = 3;
          "browser.link.open_newwindow.restriction" = 0;

          "browser.tabs.searchclipboardfor.middleclick" = false;

          "browser.ml.enable" = false;
          "browser.ml.chat.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "browser.tabs.groups.smart.userEnabled" = false;

          "extensions.webextensions.restrictedDomains" = "";
          "extensions.enabledScopes" = 5;
          "extensions.postDownloadThirdPartyPrompt" = false;
          "extensions.quarantinedDomains.enabled" = false;

          "extensions.systemAddon.update.enabled" = false;
          "extensions.systemAddon.update.url" = "";
          "extensions.webcompat-reporter.enabled" = false;
          "extensions.webcompat-reporter.newIssueEndpoint" = "";

          "app.update.auto" = false;

          "identity.fxaccounts.enabled" = false;

          "signon.rememberSignons" = false;
          "signon.autofillForms" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.formlessCapture.enabled" = false;

          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "devtools.debugger.remote-enabled" = false;
          "devtools.selfxss.count" = 0;

          "SearchEngines" = {
            "Default" = "DuckDuckGo";
            "PreventInstalls" = true;
            "Remove" = [
              "Google"
              "Bing"
            ];
          };

          "app.support.baseURL" = "https://support.librewolf.net/";
          "browser.search.searchEnginesURL" = "https://librewolf.net/docs/faq/#how-do-i-add-a-search-engine";
          "browser.geolocation.warning.infoURL" = "https://librewolf.net/docs/faq/#how-do-i-enable-location-aware-browsing";
          "app.feedback.baseURL" = "https://librewolf.net/#questions";
          "app.releaseNotesURL" = "https://codeberg.org/librewolf/source";
          "app.releaseNotesURL.aboutDialog" = "https://codeberg.org/librewolf/source";
          "app.update.url.details" = "https://codeberg.org/librewolf/source";
          "app.update.url.manual" = "https://codeberg.org/librewolf/source";

          "browser.startup.homepage_override.mstone" = "ignore";
          "startup.homepage_override_url" = "about:blank";
          "startup.homepage_welcome_url" = "about:blank";
          "startup.homepage_welcome_url.additional" = "";
          "startup.homepage_override_nimbus_disable_wnp" = true;
          "browser.uitour.enabled" = false;
          "browser.uitour.url" = "";
          "browser.shell.checkDefaultBrowser" = false;

          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories.options" = {
            "hidden" = true;
          };
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.weatherfeed" = false;
          "browser.newtabpage.activity-stream.showWeather" = false;

          "browser.contentblocking.report.lockwise.enabled" = false;
          "browser.contentblocking.report.hide_vpn_banner" = true;
          "browser.contentblocking.report.vpn.enabled" = false;
          "browser.contentblocking.report.show_mobile_app" = false;
          "browser.vpn_promo.enabled" = false;
          "browser.promo.focus.enabled" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "lightweightThemes.getMoreURL" = "";
          "browser.topsites.useRemoteSetting" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.preferences.moreFromMozilla" = false;

          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;

          "identity.fxaccounts.toolbar.pxiToolbarEnabled" = false;
          "sidebar.main.tools" = "history";

          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.previousBuildID" = "";
          "toolkit.telemetry.server_owner" = "";
          "toolkit.coverage.opt-out" = true;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.enabled" = false;
          "toolkit.coverage.endpoint.base" = "";
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.tabs.crashReporting.sendReport" = false;
          "breakpad.reportURL" = "";
          "network.connectivity-service.enabled" = false;
          "network.captive-portal-service.enabled" = false;
          "captivedetect.canonicalURL" = "";
          "dom.private-attribution.submission.enabled" = false;
          "datareporting.usage.uploadEnabled" = false;

          "librewolf.uBO.assetsBootstrapLocation" = "https://gitlab.com/librewolf-community/browser/source/-/raw/main/assets/uBOAssets.json";
          "librewolf.aboutMenu.checkVersion" = false;
          "librewolf.hidePasswdmgr" = false;
          "librewolf.debugger.force_detach" = false;
          "librewolf.console.logging_disabled" = false;
          "librewolf.services.settings.allowedCollections" = ''
            security-state/*,
            main/translations-models,
            main/translations-wasm,
            main/tracking-protection-lists,
            main/public-suffix-list
          '';
          "librewolf.services.settings.allowedCollectionsFromDump" = "main/search-config-v2,main/search-config-icons";
        };
        ExtensionSettings = {
          "jid1-ZAdIEUB7XOzOJw@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4552124/bitwarden_password_manager-latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
      };
    };

    # Firefox -> Librewolf
    environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
    
    # Brave browser (might remove)
    environment.systemPackages = with pkgs; [
      brave
    ];
  };
}
