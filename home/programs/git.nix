{ pkgs
, ...
}: {
  home.packages = [ pkgs.gh ];

  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "SamueleFacenda";
        email = "samuele.facenda@gmail.com";
      };
      pull.ff = "only";
      init.defaultBranch = "main";
    };

    signing.key = null;
    signing.signByDefault = true;

    lfs.enable = true;
  };
  
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
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
