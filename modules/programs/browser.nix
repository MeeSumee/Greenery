{
  config,
  lib,
  pkgs,
  ...
}: {
  options.greenery.programs.browser.enable = lib.mkEnableOption "Browsers";

  config = lib.mkIf (config.greenery.programs.browser.enable && config.greenery.programs.enable) {
    environment = {
      # Debloat brave
      etc."/brave/policies/managed/GroupPolicy.json".text = ''
        {
          "BraveAIChatEnabled": false,
          "BraveRewardsDisabled": true,
          "BraveWalletDisabled": true,
          "BraveVPNDisabled": true,
          "TorDisabled": true,
          "BraveP3AEnabled": false,
          "BraveStatsPingEnabled": false,
          "BraveWebDiscoveryEnabled": false,
          "BraveNewsDisabled": true,
          "BraveTalkDisabled": true,
          "BraveSpeedreaderEnabled": false,
          "BraveWaybackMachineEnabled": false,
          "BravePlaylistEnabled": false,
          "SyncDisabled": false,
          "PasswordManagerEnabled": false,
          "AutofillAddressEnabled": false,
          "AutofillCreditCardEnabled": false,
          "TranslateEnabled": false,
          "DnsOverHttpsMode": "secure",
          "DnsOverHttpsTemplates": "https://dns.adguard-dns.com/dns-query"
        }
      '';
      # Browsers
      systemPackages = with pkgs; [
        ungoogled-chromium
        brave
      ];
    };

    # Chromium Policy Editor
    programs.chromium = {
      enable = true;
      extensions = [
        # uBOL
        "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx"
        # Dark-Reader
        "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
      ];
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?q=%s";
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "en-US"
        ];
      };
    };
  };
}
