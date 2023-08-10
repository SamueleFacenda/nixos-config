{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./default-apps.nix
    ./common.nix
  ];
}
