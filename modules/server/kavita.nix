{
  lib,
  config,
  ...
}: {
  # Kavita service for hosting manga

  services.kavita = {
    enable = true;
    dataDir = "/run/media/sumee/emerald/kavita";
    settings = {
      Port = 5000;
      IpAddresses = "greenery.berylline-mine.ts.net,::";
    };
  };
}
