{ config
, pkgs
, ...
}: {
  imports = [
    ./git.nix
    ./xdg.nix
    ./common.nix
    ./dconf.nix
    ./spotify.nix
    ./kitty.nix
    ./tmux.nix
    ./vscode.nix
    ./idea.nix
    ./wakatime.nix
    ./micro.nix
    ./stylix.nix
    ./cursor.nix
    ./flameshot.nix
  ];
}
