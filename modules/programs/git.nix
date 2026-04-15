{
  config,
  lib,
  ...
}: {
  options.greenery.programs.git.enable = lib.mkEnableOption "git & git setup";

  config = lib.mkIf config.greenery.programs.enable {
    # Git, config enabled if greenery.programs.git is enabled
    programs.git = {
      enable = true;
      config = lib.mkIf config.greenery.programs.git.enable {
        user = {
          name = "MeeSumee";
          email = "79007212+MeeSumee@users.noreply.github.com";
          github = "MeeSumee";
          signingkey = "/home/sumee/.ssh/id_ed25519.pub";
        };

        commit.gpgsign = true;
        gpg.format = "ssh";
        core.editor =
          if config.greenery.programs.nvim.enable
          then "nvim"
          else "nano";
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
      };
    };
  };
}
