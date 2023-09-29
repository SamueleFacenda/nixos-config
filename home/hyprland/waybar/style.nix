{ config, pkgs, ... }: {
  programs.waybar.style = with config.lib.stylix.colors.withHashtag; ''

    * {
      border: none;
      border-radius: 0px;
      /*font-family: VictorMono, Iosevka Nerd Font, Noto Sans CJK;*/
      /*font-family: Iosevka, FontAwesome, Noto Sans CJK;*/
      font-size: 14px;
      font-style: normal;
      min-height: 0;
    }
    window#waybar {
      background: transparent;
      border-bottom: 0px solid #000000;
      color: ${cyan}
    }

    #workspaces {
    	background: ${base00};
    	margin: 5px 5px 5px 5px;
      padding: 0px 5px 0px 5px;
    	border-radius: 16px;
      border: solid 0px #f4d9e1;
      font-weight: normal;
      font-style: normal;
    }
    #workspaces button {
      padding: 0px 5px;
      border-radius: 16px;
      color: ${blue};
    }

    #workspaces button.active {
      color: ${cyan};
      background-color: transparent;
      border-radius: 16px;
    }

    #workspaces button:hover {
    	background-color: ${base04};
    	color: ${base00};
    	border-radius: 16px;
    }

    #custom-date, #clock, #battery, #pulseaudio, #network, #custom-launcher, #custom-powermenu {
    	background: transparent;
    	padding: 5px 5px 5px 5px;
    	margin: 5px 5px 5px 5px;
      border-radius: 8px;
      border: solid 0px #f4d9e1;
    }

    #tray {
      background: ${base00};
      margin: 5px 5px 5px 5px;
      border-radius: 16px;
      padding: 0px 5px;
      /*border-right: solid 1px #282738;*/
    }

    #custom-powermenu {
      background: ${base00};
      color: ${cyan};
      border-radius: 16px;
      padding: 0px 5px;
      /*border-right: solid 1px #282738;*/
    }

    #clock {
      color: ${base05};
      background-color: ${brown};
      border-radius: 0px 0px 24px 24px;
      padding-left: 13px;
      padding-right: 15px;
      margin-right: 0px;
      margin-left: 10px;
      margin-top: 0px;
      margin-bottom: 0px;
      font-weight: bold;
      /*border-left: solid 1px #282738;*/
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
      border-radius: 5px 5px 5px 5px;
    }

    #network {
      color: ${cyan};
      border-radius: 8px;
      margin-right: 5px;
    }

    #pulseaudio {
      color: ${cyan};
      border-radius: 8px;
      margin-left: 0px;
    }

    #pulseaudio.muted {
      background: transparent;
      color: ${blue};
      border-radius: 8px;
      margin-left: 0px;
    }

    #custom-launcher {
      color: ${base05};
      background-color: ${brown};
      border-radius: 0px 0px 24px 0px;
      margin: 0px 0px 0px 0px;
      padding: 0 20px 0 13px;
      /*border-right: solid 1px #282738;*/
      font-size: 20px;
    }

    #custom-launcher button:hover {
      background-color: ${cyan};
      color: transparent;
      border-radius: 8px;
      margin-right: -5px;
      margin-left: 10px;
    }

    #cpu {
      background-color: ${base00};
      /*color: #FABD2D;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }

    #memory {
      background-color: ${base00};
      /*color: #83A598;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }
  '';
}
