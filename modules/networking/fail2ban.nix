{ 
  config, 
  lib, 
  ...
}: {

  options.greenery.networking.fail2ban.enable = lib.mkEnableOption "fail2ban service";

  config = lib.mkIf (config.greenery.networking.fail2ban.enable && config.greenery.networking.enable) {

    services.fail2ban = {
      enable = true;
      maxretry = 3;
      ignoreIP = [
        "greenery.onca-ph.ts.net"
        "beryl.onca-ph.ts.net"
        "obsidian.onca-ph.ts.net"
        "kaolin.onca-ph.ts.net"
        "quartz.onca-ph.ts.net"
      ];
      bantime = "48h";
      bantime-increment = {
        enable = true;
        formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        # multipliers = "1 2 4 8 16 32 64 128"; # same functionality as above
        # Do not ban for more than 10 weeks
        maxtime = "1680h";
        overalljails = true;
      };
    };
  };
}
