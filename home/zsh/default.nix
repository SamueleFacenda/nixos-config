{config,  lib, pkgs, ...}: {
	programs.zsh = {
	  enable = true;
	  enableAutosuggestions = true;
	  enableCompletion = true;
	  shellAliases = {
	    ll = "ls -l";
	    update = "sudo nixos-rebuild switch --flake /nixos-config#surface";
	  };
	  history = {
	    size = 10000;
	    path = "${config.xdg.dataHome}/zsh/history";
	  };

	  # plugins with oh-my-zsh
	  oh-my-zsh = {
	    enable = true;
	    plugins = [ 
	    	"git"
		"sudo" 
	    ];
	    # theme = "robbyrussell";
	  };

	# manual plugins
	plugins = [
		  {
		    name = "powerlevel10k";
		    src = pkgs.zsh-powerlevel10k;
		    file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
		  }
		    {
		    name = "powerlevel10k-config";
		    src = lib.cleanSource ./p10k-config;
		    file = "p10k.zsh";
		  }
	];
  };
}
