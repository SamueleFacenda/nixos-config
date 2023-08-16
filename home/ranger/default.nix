{config, pkgs, ...}:{
	home.file.".config/ranger" = {
		source = ./config;
		recursive = true;
	};
	home.sessionVariables.RANGER_LOAD_DEFAULT_RC = "false";
}
