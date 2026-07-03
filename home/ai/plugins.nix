{ pkgs, lib, ... }: {
  ai.plugins = {
    ponytail = pkgs.fetchFromGitHub {
      repo = "ponytail";
      owner = "DietrichGebert";
      rev = "v4.8.4";
      hash = "sha256-1A9GkjCuiqwd6Wxl18CZUGYekxrbeTLVDapNUua8ihg=";
    };
    token-optimizer = pkgs.fetchFromGitHub {
      repo = "token-optimizer";
      owner = "alexgreensh";
      rev = "v5.11.30";
      hash = "sha256-5jgmmtB05UuTIZYfoev7+WI6PFH1Ot1+jYi9H5+Yg1w=";
      postFetch = ''
        substituteInPlace "$out/hooks/python-launcher.sh" \
          --replace /opt/homebrew/opt /nix/store 
      '';
    };
  };
}
