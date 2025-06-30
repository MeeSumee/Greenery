{ config, lib, sources, inputs, users, pkgs, ...}:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    micro
  ];

  hjem.users = lib.genAttrs users (user: {
    enable = true;
    directory = config.users.users.${user}.home;
    clobberFiles = lib.mkForce true;
    files = {
      ".config/micro/plug/lsp".source = sources.micro-plugin-lsp;
      ".config/micro/plug/bounce".source = sources.micro-bounce;
      ".config/micro/plug/quoter".source = sources.micro-quoter;
    };
  });
}
