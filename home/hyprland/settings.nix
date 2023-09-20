lib :
{
  monitor = [
    # "eDP-1,2736x1824,1440x1050,2" # builtin
    "eDP-1,2736x1824,0x900,2" # builtin
    "DP-3,1680x1050,1440x0,1" # big fujitsu
    "DP-4,1440x900,0x0,1" # small asus
    "DP-6,1440x900,0x0,1" # small asus
  ];

  input = {
    follow_mouse = 1;
    touchpad.natural_scroll = true;
  };

  general = {
    layout = "dwindle";
  };

  animations = {
    enabled = true;
  };

  dwindle = {
    preserve_split = true;
    pseudotile = true;
  };

  master = {
    new_is_master = true;
  };

  gestures = {
    workspace_swipe = true;
  };

  misc = {
    force_hypr_chan = false;
    disable_splash_rendering = true;
    disable_hyprland_logo = true;
  };

  decoration = {
    rounding = 19;
    blur = {
      enabled = true;
      size = 14;
      passes = 3;
      new_optimizations = true;
    };
    drop_shadow = true;
    shadow_range = 15;
    "col.shadow" = lib.mkDefault "0xffa7caff";
    "col.shadow_inactive" = "0x50000000";

    active_opacity = 1.0;
    inactive_opacity = 0.97;
    blurls = [
      "waybar"
      "lockscreen"
    ];

  };

}
