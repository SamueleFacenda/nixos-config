{ config, pkgs, lib, ... }: {
  programs.kitty = {
    enable = true;
    font.name = lib.mkForce "Monofur Nerd Font Mono"; # "JetBrainsMono Nerd Font";#"monofurx Nerd Font";#
    font.size = lib.mkForce 15;
    # theme = "Adwaita dark";
    # theme = "GitHub Dark";
    environment = {
      # ZLE_RPROMPT_INDENT = "0";
      TERMINAL = "kitty";
    };

    settings = with config.lib.stylix.colors.withHashtag; {
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      disable_ligatures = "cursor";
      # font_features = "MonofurNF "
      background = "${base02}";
      foreground = "${base05}";
      background_opacity = lib.mkDefault "0.3";
      #background_blur = "30"; # not supported on wayland
      window_padding_width = "10";
      dynamic_background_opacity = "yes";
      active_border_color = "${orange}";
      inactive_border_color = "${brown}";
      bell_border_color = "${magenta}";

      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_foreground = "${base05}";
      active_tab_background = "${base02}";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "${base06}";
      inactive_tab_background = "${base00}";
      inactive_tab_font_style = "normal";
      tab_bar_background = "${base00}";

      enable_audio_bell = "no";
      bell_on_tab = "🔔";
      visual_bell_duration = "0.0";

      wayland_titlebar_color = "system";
    };
  };
}
