{config, pkgs, ...}:{
	age.secrets.github-token = {
		file = ./github-token.age;
		
	}

	age.secrets.wakatime-key = {
		file = ./wakatime-key.age;
	}
}
