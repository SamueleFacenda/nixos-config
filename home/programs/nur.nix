{ config, pkgs, nur, ... }: {
  imports = [
    nur.modules.homeManager.default
  ];

  # home.packages = with config.nur.repos."999eagle"; [
  #   github-linguist
  # ];
}
