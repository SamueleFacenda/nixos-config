{ config, pkgs, ...}:{
  xdg.configFile."nwg-bar/bar.json".text = builtins.toJSON [
    {
      label = "Lock";
      exec = "${pkgs.swaylock-effects}/bin/swaylock -f --screenshot --effect-blur 10x7";
      icon = "${pkgs.nwg-bar}/share/nwg-bar/images/system-lock-screen.svg";
    }
    {
      label = "Logout";
      exec = "hyprctl dispatch exit";
      icon = "${pkgs.nwg-bar}/share/nwg-bar/images/system-log-out.svg";
    }
    {
      label = "Reboot";
      exec = "reboot";
      icon = "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg";
    }
    {
      label = "Shutdown";
      exec = "shutdown now";
      icon = "${pkgs.nwg-bar}/share/nwg-bar/images/system-shutdown.svg";
    }
  ];
  xdg.configFile."nwg-bar/style.css".text = with config.lib.stylix.colors.withHashtag; ''
    window {
      background-color: transparent
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
    	margin: 5px
    }

    button:hover {
    	background-color: ${cyan};
    }

  '';
}
