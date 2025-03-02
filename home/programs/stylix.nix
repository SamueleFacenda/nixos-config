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
      vscode.enable = false;
      spicetify.enable = false;
      micro.enable = false;
      gnome-text-editor.enable = false; # https://www.reddit.com/r/NixOS/comments/1ivo70f/comment/mea7qgm/
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
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 11;
          desktop = 11;
          popups = 11;
          terminal = 15;
        };
      };
  };
}
