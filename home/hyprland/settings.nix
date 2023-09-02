{
  monitor = [
    "eDP-1,2736x1824,1440x1050,2" # builtin
    "DP-3,1680x1050,1440x0,1" # big fujitsu
    "DP-4,1440x900,0x0,1" # small asus
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
  };
}
