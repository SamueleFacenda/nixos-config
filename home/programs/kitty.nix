{config, pkgs, ...}: {
	programs.kitty = {
		enable = true;
		font.name = "Monofur Nerd Font Mono";
		font.size = 15;
		# theme = "Adwaita dark";

		environment = {
			ZLE_RPROMPT_INDENT = "0";
		};

		settings = {
			clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
		};
	};
}
