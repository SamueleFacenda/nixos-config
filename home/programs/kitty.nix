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
      foreground = "${base06}";
      background_opacity = lib.mkDefault "0.5";
      #background_blur = "30"; # not supported on wayland
      window_padding_width = "7";
      dynamic_background_opacity = "yes";
      active_border_color = "${orange}";
      inactive_border_color = "${brown}";
      bell_border_color = "${magenta}";

      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_foreground = "${base05}";
      active_tab_background = "${base02}";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "${base04}";
      inactive_tab_background = "${base00}";
      inactive_tab_font_style = "normal";
      tab_bar_background = "${base00}";

      enable_audio_bell = "no";
      bell_on_tab = "🔔";
      visual_bell_duration = "0.0";

      wayland_titlebar_color = "system";
/*
      color0 = "${base00}";
      color1 = "${red}";
      color2 = "${green}";
      color3 = "${yellow}";
      color4 = "${blue}";
      color5 = "${magenta}";
      color6 = "${cyan}";
      color7 = "${base05}";
      color8 = "${base03}";
      color9 = "${base03}";
      color10 = "${red}";
      color11 = "${green}";
      color12 = "${yellow}";
      color13 = "${blue}";
      color14 = "${magenta}";
      color15 = "${cyan}";
      color16 = "${base07}";*/
    };
  };
}
