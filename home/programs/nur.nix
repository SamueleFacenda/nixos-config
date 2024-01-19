{config, pkgs, nur, ...}:{
  imports = [
    nur.hmModules.nur
  ];

  home.packages = with config.nur.repos."999eagle"; [
    github-linguist
  ];
}
