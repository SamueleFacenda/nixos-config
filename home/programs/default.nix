{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./default-apps.nix
    ./common.nix
    ./dconf.nix
    ./spotify.nix
    ./kitty.nix
	./tmux.nix
  ];
}
