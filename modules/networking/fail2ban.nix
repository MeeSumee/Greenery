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
        "greenery.berylline-mine.ts.net"
        "beryl.berylline-mine.ts.net"
        "garnet.berylline-mine.ts.net"
        "kaolin.berylline-mine.ts.net"
        "quartz.berylline-mine.ts.net"
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
