{ config, pkgs, ... }: {
  programs.waybar.style = with config.lib.stylix.colors.withHashtag; ''

    * {
      border: none;
      border-radius: 0px;
      font-size: 14px;
      font-style: normal;
      min-height: 0;
      color: ${cyan}
    }

    window#waybar {
      background: transparent;
      border-bottom: 0px solid #000000;
    }

    /* Transparent background, light text */
    #battery, #pulseaudio, #network, #language{
    	background: transparent;
    	padding: 5px 5px 5px 5px;
    	margin: 5px 5px 5px 5px;
    }

    /* Dark background, cyan text, pill shape */
    #cpu, #memory, #temperature, #custom-powermenu, #workspaces, #tray{
    	background: ${base01};
    	margin: 5px 5px 5px 5px;
      padding: 0px 5px 0px 5px;
    	border-radius: 16px;
    }

    #custom-launcher {
      color: ${base05};
      background-color: ${brown};
      border-radius: 0px 0px 24px 0px;
      margin: 0px 0px 0px 0px;
      padding: 0 20px 0 13px;
      font-size: 20px;
    }

    #custom-launcher button:hover {
      background-color: ${cyan};
      color: transparent;
      border-radius: 8px;
      margin-right: -5px;
      margin-left: 10px;
    }

    #workspaces {
      margin: 5px 40px;
    }

    #workspaces button {
      padding: 0px 5px;
      border-radius: 16px;
      color: ${blue};
    }

    /* Does this works?(seems to be overwritten in child labe) */
    #workspaces button.active {
      color: ${red};
      background-color: transparent;
    }

    #workspaces button:hover {
    	background-color: ${base04};
    	color: ${base00};
    }

    #language {}

    #clock {
      color: ${base05};
      background-color: ${brown};
      border-radius: 0px 0px 24px 24px;
      padding-left: 13px;
      padding-right: 15px;      margin-top: 0px;
      margin-bottom: 0px;
      font-weight: bold;
    }

    #cpu, #memory ,#temperature{
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }

    #tray {}

    #network {}

    #pulseaudio {}

    #pulseaudio.muted {
      color: ${blue};
    }

    #battery {
      color: ${base07};
    }

    #battery.charging {
      color: ${green};
    }

    #battery.warning:not(.charging) {
      background-color: ${red};
      color: ${base00};
    }

    #custom-powermenu {
      /*padding: 0px 13px 0px 10px;*/
      padding: 0px 30px 0px 30px;
    }
  '';
}
