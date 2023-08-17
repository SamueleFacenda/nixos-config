{config,  lib, pkgs, ...}: {
  programs.zsh = {
	enable = true;
	enableAutosuggestions = true;
	enableCompletion = true;
	autocd = true;
	syntaxHighlighting.enable = true;

	shellAliases = {
	  update = "sudo nixos-rebuild switch --flake /nixos-config |& nom";
	  free-space = "sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system && sudo nix store gc --debug";
	  # rm = "trash put";
	  
	  ls = "exa --icons --group-directories-first";
	  ll = "exa --icons --long --git --group-directories-first";
	  la = "exa --icons --long --git --all --group-directories-first";
	  tree = "exa --icons --tree";
	  
	  c = "clear";
	  q = "exit";
	  rl = "omz reload";
	  search = "nix search nixpkgs";

	  nix-build = "nom-build";
	  nix-shell = "nom-shell";
	  nix = "nom";
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
		"z"
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
	  {
	  	name = "wakatime";
	  	src = pkgs.fetchFromGitHub {
	  		owner = "sobolevn";
	  		repo = "wakatime-zsh-plugin";
	  		rev = "69c6028b0c8f72e2afcfa5135b1af29afb49764a"; # latest commit as of 12 august 2023
	  		sha256 = "pA1VOkzbHQjmcI2skzB/OP5pXn8CFUz5Ok/GLC6KKXQ=";
	  	};
	  }
	];

	# enable p10k instant prompt
	initExtraFirst = 
	  ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
  };

  # needed config for zsh wakatime plugin
  home.sessionVariables.ZSH_WAKATIME_BIN = "${pkgs.wakatime}/bin/wakatime-cli";

  # remove the right side 1 char padding
  home.sessionVariables.ZLE_RPROMPT_INDENT = "0";
}
