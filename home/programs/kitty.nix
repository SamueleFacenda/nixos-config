{config, pkgs, ...}: {
	programs.kitty = {
		enable = true;
		font.name = "Monofur Nerd Font Mono"; # "JetBrainsMono Nerd Font";
		font.size = 15;
		# theme = "Adwaita dark";
        # theme = "GitHub Dark";
		environment = {
			# ZLE_RPROMPT_INDENT = "0";
		};

		settings = {
			clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
			disable-ligatures = "cursor";
			# font_features = "MonofurNF "
			background = "#292929";
			background_opacity = "0.85";
			background_blur = "30"; # not supported on wayland
			dynamic_background_opacity = "yes";
			
			wayland_titlebar_color = "system";
		};
	};
}
