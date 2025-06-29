{ config, pkgs, ... }: {
  programs.waybar.style = with config.lib.stylix.colors.withHashtag; ''

    * {
      font-size: 14px;
      font-style: normal;
      min-height: 0;
      color: ${cyan};
      font-family: 'DejaVu Sans';
    }

    window#waybar {
      background: transparent;
      border-bottom: 0px solid #000000;
    }

    tooltip {
      background-color: ${base00};
      color: ${cyan};
      border-radius: 16px;
    }

    /* Transparent background, light text */
    taskbar {
    	background: transparent;
    	padding: 5px 5px 5px 5px;
    	margin: 5px 5px 5px 5px;
    }

    /* Dark background, cyan text, pill shape */
    #tray, #custom-left-icon, #network, #cpu, #memory, #temperature, #custom-powermenu, #custom-osk, #workspaces, #battery, #wireplumber, #network, #language, #idle_inhibitor{
    	background: ${base01};
    	margin: 5px 5px 5px 5px;
      padding: 5px 10px 5px 10px;
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

    #taskbar {
      margin: 5px;
    }

    #workspaces {
      margin: 5px 40px;
      padding: 0px;
    }

    #workspaces button {
      padding: 0px 6px;
      border-radius: 16px;
      color: ${blue};
    }

    #workspaces label{
      font-family: 'JetBrainsMono NerdFont Mono';
    }
    
    #workspaces button.active label{
     font-size: 20px;
    }

    #workspaces button:hover {
    	background-color: ${base04};
    	color: ${base00};
    }

    #language {}
    
    #traydrawer {
      padding: 0px;
    }
    
    /* Remove rounded border from left icon when drawer expands  */
    #traydrawer:hover #custom-left-icon {
      border-radius: 0px;
      margin-left: 0px;
      padding-left: 15px;
    }
    
    #traydrawer:not(:hover) #custom-left-icon {
      border-radius: 16px 0px 0px 16px;
      transition-property: all;
      transition-delay: 0.26s;
      transition-duration: 0.2s;
    }

    #clock {
      color: ${base05};
      background-color: ${brown};
      border-radius: 0px 0px 24px 24px;
      padding-left: 13px;
      padding-right: 15px;      
      margin-top: 0px;
      margin-bottom: 0px;
      font-weight: bold;
    }

    #cpu, #memory ,#temperature{
      font-weight: bold;
    }

    /* LEFT  MODULES */
    #temperature, #custom-left-icon, #tray {
      border-radius: 16px 0px 0px 16px;
      margin-right: 0px;
      padding: 5px 3px 5px 10px;
    }

    /* CENTER MODULES */
    #network, #memory, #wireplumber, #battery, #idle_inhibitor, #custom-osk{
      border-radius: 0px;
      margin-right: 0px;
      margin-left: 0px;
      padding: 5px 3px 5px 3px;
    }

    /* RIGHT MODULES */
    #cpu, #language {
      border-radius: 0px 16px 16px 0px;
      margin-left: 0px;
      padding: 5px 10px 5px 3px;
    }

    #idle_inhibitor, #custom-osk {
      padding-right: 5px;
    }

    #wireplumber.muted {
      color: ${blue};
    }

    @keyframes charging {
      from { color: ${base03}; }
      to { color: ${green}; }
    }

    @keyframes warning {
      from { background-color: ${base01}; }
      to { background: radial-gradient(ellipse closest-side at center, ${orange} 50%, ${base01} 100%); }
    }

    @keyframes critical {
      from { background-color: ${base01}; }
      to { background: radial-gradient(ellipse closest-side at center, ${red} 50%, ${base01} 100%); }
    }

    #battery.charging {
      animation-name: charging;
      animation-duration: 2s;
      animation-direction: alternate;
      animation-timing-function: cubic-bezier(.59,.23,.25,.91);
      animation-iteration-count: infinite;
    }

    #battery.full {
      color: ${green};
    }

    #battery.critical:not(.charging) {
      /* animation-name: critical;
      animation-duration: 1s;
      animation-direction: alternate;
      animation-timing-function: cubic-bezier(.59,.23,.25,.91);
      animation-iteration-count: infinite; */
      color: ${red};
    }

    #battery.warning:not(.charging) {
      /* animation-name: warning;
      animation-duration: 2s;
      animation-direction: alternate;
      animation-timing-function: cubic-bezier(.59,.23,.25,.91);
      animation-iteration-count: infinite; */
      color: ${red};
    }

    /* !!!! During a transition(battery blinking) the background is shown. This sets the background of the
    battery parent (a widget) to something different from transparent. Using the css selector E:has() is a better
    way to do that, but it is not supported in gtk3. (the battery is the 6th node of the right elements) */
    box.modules-right > widget:nth-child(7) {
    	background: content-box ${base01};
    	padding: 5px 0px;
    }

    #custom-powermenu {
      padding: 0px 13px 0px 10px;
      /*padding: 0px 30px 0px 30px;*/
    }
  '';
}
