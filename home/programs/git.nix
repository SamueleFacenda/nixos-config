{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "SamueleFacenda";
    userEmail = "samuele.facenda@gmail.com";
  };
}
