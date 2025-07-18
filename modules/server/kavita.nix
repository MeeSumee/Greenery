{
  lib,
  config,
  ...
}: {
  # Kavita service for hosting manga

  services.kavita = {
    enable = true;
    tokenKeyFile = "/home/administrator/tokenkey/kkeygen";
    settings = {
      Port = 5000;
#      IpAddresses = "100.81.192.125,::";
    };
  };
}
