{config, pkgs, ...}: {
	programs.kitty = {
		enable = true;
		font.name = "Monofur Nerd Font Mono"; # "JetBrainsMono Nerd Font";
		font.size = 15;
		# theme = "Adwaita dark";
        # theme = "GitHub Dark";
		environment = {
			# ZLE_RPROMPT_INDENT = "0";
			TERMINAL = "kitty";
		};

		settings = {
			clipboard_control = "write-clipboard write-primary read-clipboard read-primary";
			disable_ligatures = "cursor";
			# font_features = "MonofurNF "
			background = "#292929";
			background_opacity = "0.85";
			background_blur = "30"; # not supported on wayland
			dynamic_background_opacity = "yes";
			
			enable_audio_bell = "no";
			bell_on_tab = "🔔";
			visual_bell_duration = "0.0";
			
			wayland_titlebar_color = "system";
		};
	};
}
