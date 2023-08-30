{config, pkgs, ...}:{
 
  age.secrets = {
    github-token = {
  	  file = ./github-token.age;
    };

    wakatime-key = {
      file = ./wakatime-key.age;
      owner = "samu";
      group = "users";
      fillPlaceholdersFiles = ["/home/samu/.wakatime.cfg"];
    };
  };

  age.identityPaths = [ 
    "/home/samu/.ssh/id_rsa"
    "/home/samu/.ssh/id_ed25519"
  ];
}
