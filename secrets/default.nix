{config, pkgs, ...}:{
 
  age.secrets = {
    github-token = {
  	  file = ./github-token.age;
    };

    wakatime-key = {
      file = ./wakatime-key.age;
    };
  };

  age.identityPaths = [ 
    "/home/samu/.ssh/id_rsa"
    "/home/samu/.ssh/id_ed25519"
  ];

  age.fill-placeholders.wakatime-key = "/home/samu/.wakatime.cfg";
}
