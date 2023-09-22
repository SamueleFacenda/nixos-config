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
    touchpad.natural_scroll = true;

    kb_layout = "us,it";
    kb_options = "grp:win_space_toggle,caps:escape_shifted_capslock";

    repeat_rate = 25;
    repeat_delay = 500;

    follow_mouse = 2; # keyboard focus don't change until click on window
  };

  "device:ipts-stylus" = {
    transform = 0;
    output = "eDP-1";
  };


  "device:ipts-touch" = {
    transform = 0;
    output = "eDP-1";
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
    #disable_hypr_chan = true; does not work
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
