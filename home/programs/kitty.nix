{config, pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font.name = "Monofur Nerd Font Mono"; # "JetBrainsMono Nerd Font";
    font.size = 15;
    # theme = "Adwaita dark";
        # theme = "GitHub Dark";
    environment = {
      # ZLE_RPROMPT_INDENT = "0";
      TERMINAL = "kitty";
    };

    settings = {
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
      disable_ligatures = "cursor";
      # font_features = "MonofurNF "
      background = "#14151e";
      foreground = "#98b0d3";
      background_opacity = "0.3";
      #background_blur = "30"; # not supported on wayland
      window_padding_width = "10";
      dynamic_background_opacity = "yes";
      active_border_color ="#3d59a1";
      inactive_border_color ="#101014";
      bell_border_color = "#fffac2";
      
      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_foreground  ="#3d59a1";
      active_tab_background  ="#16161e";
      active_tab_font_style  ="bold";
      inactive_tab_foreground ="#787c99";
      inactive_tab_background ="#16161e";
      inactive_tab_font_style ="bold";
      tab_bar_background ="#101014";
      
      enable_audio_bell = "no";
      bell_on_tab = "🔔";
      visual_bell_duration = "0.0";
      
      wayland_titlebar_color = "system";
    };
  };
}
