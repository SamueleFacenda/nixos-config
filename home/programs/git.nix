{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "SamueleFacenda";
    userEmail = "samuele.facenda@gmail.com";

    signing.key = "0DB83F58B2596271";
    signing.signByDefault = true;

    lfs.enable = true;

    delta.enable = true;
    delta.options = {
      line-numbers = true;
    };
  };

  programs.git-credential-oauth.enable = false;
}
