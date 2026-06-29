{ pkgs, lib, ... }: {
  ai.plugins = {
    poytail = pkgs.fetchFromGitHub {
      repo = "ponytail";
      owner = "DietrichGebert";
      rev = "v.4.8.4";
      hash = "";
    };
  };
}
