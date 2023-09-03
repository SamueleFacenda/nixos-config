{
  "$mod" = "SUPER";
 
  
  bind = [
    "$mod, Q, exec, kitty"
    "$mod, C, killactive,"
    "$mod, M, exit,"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"        
  ];
  
  bindl = [
    # Lid switch settings
  	#",switch:Lid Switch,exec,swaylock"
  	
  	",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1,2736x1824,1440x1050,2\""
  	#",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3,1680x1050,1440x0,1\""
  	#",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4,1440x900,0x0,1\""

  	",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
  	#",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-3, disable\""
  	#",switch:on:Lid Switch,exec,hyprctl keyword monitor \"DP-4, disable\""
  ];
}
