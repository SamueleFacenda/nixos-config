{ config, pkgs, ... }: {
  programs.waybar.style = ''

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
      background: rgba(0,0,0,0);
      border-bottom: 0px solid #000000;
      color: #88c0d0
    }

    #window {
      background: rgba(0,0,0,0);
      padding-left: 15px;
      padding-right: 15px;
      border-radius: 16px;
      /*border-left: solid 1px #282738;*/
      /*border-right: solid 1px #282738;*/
      margin-top: 5px;
      margin-bottom: 5px;
      font-weight: normal;
      font-style: normal;
    }

    #workspaces {
    	background: #282828;
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
      color: #88c0d0;
    }

    #workspaces button.active {
      color: #88c0d0;
      background-color: transparent;
      border-radius: 16px;
    }

    #workspaces button:hover {
    	background-color: #E6B9C6;
    	color: black;
    	border-radius: 16px;
    }

    #custom-date, #clock, #battery, #pulseaudio, #network, #custom-randwall, #custom-launcher {
    	background: transparent;
    	padding: 5px 5px 5px 5px;
    	margin: 5px 5px 5px 5px;
      border-radius: 8px;
      border: solid 0px #f4d9e1;
    }

    #custom-date {
    	color: #88c0d0;
    }

    #tray {
      background: #282828;
      margin: 5px 5px 5px 5px;
      border-radius: 16px;
      padding: 0px 5px;
      /*border-right: solid 1px #282738;*/
    }

    #clock {
      color: #88c0d0;
      background-color: #282828;
      border-radius: 0px 0px 0px 24px;
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
      color: #9ece6a;
    }

    #battery.charging {
      color: #9ece6a;
    }

    #battery.warning:not(.charging) {
      background-color: #f7768e;
      color: #24283b;
      border-radius: 5px 5px 5px 5px;
    }

    #backlight {
      background-color: #24283b;
      color: #88c0d0;
      border-radius: 0px 0px 0px 0px;
      margin: 5px;
      margin-left: 0px;
      margin-right: 0px;
      padding: 0px 0px;
    }

    #network {
      color: #88c0d0;
      border-radius: 8px;
      margin-right: 5px;
    }

    #pulseaudio {
      color: #88c0d0;
      border-radius: 8px;
      margin-left: 0px;
    }

    #pulseaudio.muted {
      background: transparent;
      color: #88c0d0;
      border-radius: 8px;
      margin-left: 0px;
    }

    #custom-randwall {
      color: #f4d9e1;
      border-radius: 8px;
      margin-right: 0px;
    }

    #custom-launcher {
      color: #88c0d0;
      background-color: #282828;
      border-radius: 0px 24px 0px 0px;
      margin: 0px 0px 0px 0px;
      padding: 0 20px 0 13px;
      /*border-right: solid 1px #282738;*/
      font-size: 20px;
    }

    #custom-launcher button:hover {
      background-color: #FB4934;
      color: transparent;
      border-radius: 8px;
      margin-right: -5px;
      margin-left: 10px;
    }

    #custom-playerctl {
    	background: #282828;
    	padding-left: 15px;
      padding-right: 14px;
    	border-radius: 16px;
      /*border-left: solid 1px #282738;*/
      /*border-right: solid 1px #282738;*/
      margin-top: 5px;
      margin-bottom: 5px;
      margin-left: 0px;
      font-weight: normal;
      font-style: normal;
      font-size: 16px;
    }

    #custom-playerlabel {
      background: transparent;
      padding-left: 10px;
      padding-right: 15px;
      border-radius: 16px;
      /*border-left: solid 1px #282738;*/
      /*border-right: solid 1px #282738;*/
      margin-top: 5px;
      margin-bottom: 5px;
      font-weight: normal;
      font-style: normal;
    }

    #custom-wf-recorder {
      padding: 0 20px;
      color: #e5809e;
      background-color: #1E1E2E;
    }

    #cpu {
      background-color: #282828;
      /*color: #FABD2D;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }

    #memory {
      background-color: #282828;
      /*color: #83A598;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }

    #disk {
      background-color: #282828;
      /*color: #8EC07C;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 10px 0px 10px;
      font-weight: bold;
    }

    #custom-hyprpicker {
      background-color: #282828;
      /*color: #8EC07C;*/
      border-radius: 16px;
      margin: 5px;
      margin-left: 5px;
      margin-right: 5px;
      padding: 0px 11px 0px 9px;
      font-weight: bold;
    }
  '';
}
