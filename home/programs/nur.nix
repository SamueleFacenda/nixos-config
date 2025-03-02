{ config, pkgs, nur, ... }: {
  imports = [
    # temporaly disable until used, it raise a warning for using nixpkgs.overlays while having set useGlobalPackages
    # nur.modules.homeManager.default
  ];

  # home.packages = with config.nur.repos."999eagle"; [
  #   github-linguist
  # ];
}
