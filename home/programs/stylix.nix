{ config, pkgs, ... }:

{
  gtk.iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };

  stylix = {
    enable = true;
  
    targets = {
      gnome.enable = true;
      kitty.enable = false;
      waybar.enable = false;
      micro.enable = false;
      swaync.enable = false;
      hyprlock.enable = false;
      gnome-text-editor.enable = false; # https://www.reddit.com/r/NixOS/comments/1ivo70f/comment/mea7qgm/
      gtksourceview.enable = false; # https://github.com/nix-community/stylix/issues/2318
    };

    cursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;
    };

    fonts =
      {      
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };

        sansSerif = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 11;
          desktop = 10;
          popups = 10;
          terminal = 12;
        };
      };
  };
}
