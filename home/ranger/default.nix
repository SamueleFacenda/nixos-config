{config, pkgs, ...}:{
	home.file.".config" = {
		source = ./ranger;
		recursive = true;
	}
}
