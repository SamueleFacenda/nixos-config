{config, pkgs, ...}:{

  programs.hyprland.enable = true;

  # swaylock ask password
	security.pam.services.swaylock = {
	  text = ''
	    auth include login
	  '';
	};
	
	# LidSwitch and PowerButton actions
  services.logind = {
  	powerKey = "suspend";
  	lidSwitchExternalPower = "suspend";
  	lidSwitchDocked = "ignore";
  	lidSwitch = "suspend";
  };
  
  environment.systemPackages = with pkgs; [
	  inotify-tools
    killall
    (callPackage ../packages/xdg-desktop-portal-shana.nix {})
  ];
  
  # enable file choser on gtk apps
  xdg.portal.gtkUsePortal = true;
}