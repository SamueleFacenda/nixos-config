{config, pkgs, ...}:{
	programs.tmux = {
		enable = true;
		baseIndex = 1;
		clock24 = true;
		disableConfirmationPrompt = false;
		mouse = true;
		keyMode = "emacs"; # or "vi"
		reverseSplit = false;
		terminal = "tmux-256color";

		extraConfig = ''
			# True colour support
			set -as terminal-overrides ",xterm*:Tc"
		'';
	};
}
