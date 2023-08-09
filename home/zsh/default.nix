{config,  pkgs, ...}: {
	programs.zsh = {
	  enable = true;
	  enableAutosuggestions = true;
	  enableCompletion = true;
	  shellAliases = {
	    ll = "ls -l";
	    update = "sudo nixos-rebuild switch /nixos-config#surface";
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
	    ];
	    theme = "robbyrussell";
	  };
	};
}
