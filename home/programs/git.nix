{ pkgs
, ...
}: {
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;

    userName = "SamueleFacenda";
    userEmail = "samuele.facenda@gmail.com";

    extraConfig = {
      pull.ff = "only";
      init.defaultBranch = "main";
    };

    signing.key = null;
    signing.signByDefault = true;

    lfs.enable = true;

    delta.enable = true;
    delta.options = {
      line-numbers = true;
    };
  };

  programs.git-credential-oauth.enable = false;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      version = 1;
    };
  };
}
