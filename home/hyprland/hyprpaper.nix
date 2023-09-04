{config, pkgs, self, ...}:{
	home.file.".config/hypr/hyprpaper.conf" = {
		text = ''
		  preload = ${self.outPath}/assets.bg1.pnghttps://github.com/NixOS/nixos-artwork/blob/master/wallpapers/nix-wallpaper-watersplash.png?raw=true
		''
	}
}