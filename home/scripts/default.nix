{config, pkgs, ...}:{

	imports = [
		./waybar.nix
	];
	
  home.file.".scripts" = {
    executable = true;
    source = ./files;
    recursive = true;
  };
}
