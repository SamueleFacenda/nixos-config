{ config, pkgs, utils, ... }: {
  xdg.configFile."nwg-bar/bar.json".text = builtins.toJSON [
    {
      label = "Lock";
      exec = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshot --effect-blur 10x7";
      icon = "system-lock-screen-symbolic";
    }
    {
      label = "Logout";
      exec = "hyprctl dispatch exit";
      icon = "system-log-out-symbolic";
    }
    {
      label = "Reboot";
      exec = "reboot";
      icon = "system-reboot-symbolic";
    }
    {
      label = "Shutdown";
      exec = "shutdown now";
      icon = "system-shutdown-symbolic";
    }
  ];

  # Power profile choose
  xdg.configFile."nwg-bar/power.json".text = builtins.toJSON [
    {
      label = "Performance";
      exec = "powerprofilesctl set performance";
      icon = "power-profile-performance-symbolic";
    }
    {
      label = "Balanced";
      exec = "powerprofilesctl set balanced";
      icon = "power-profile-balanced-symbolic";
    }
    {
      label = "Power Saver";
      exec = "powerprofilesctl set power-saver";
      icon = "power-profile-power-saver-symbolic";
    }
  ];

  xdg.configFile."nwg-bar/style.css".text = with config.lib.stylix.colors.withHashtag; ''
    window {
      background-color: transparent;
      color: ${base05};
    }

    /* Outer bar container, takes all the window width/height */
    #outer-box {
    	margin: 0px
    }

    /* Inner bar container, surrounds buttons */
    #inner-box {
    	background-color: alpha(${base00}, 0.95);
    	border-radius: 10px;
    	border-style: none;
    	border-width: 1px;
    	border-color: alpha(${cyan}, 0.7);
    	padding: 5px;
    	margin: 5px
    }

    image {
    	background: none;
    	border: none;
    	box-shadow: none;
    }

    button {
      background: none;
    	padding-left: 10px;
    	padding-right: 10px;
    	border-style: solid;
    	border-width: 2px;
    	border-color: transparent;
    	margin: 5px;
    }

    button:hover {
    	background-color: ${cyan};
    	color: ${base00}
    }

  '';
}
