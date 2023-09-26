# My nixos Flake:snowflake:

This is more than my config, it's a flake. There are a couple packages and some devshells.
### Packages:
- xdg-desktop-portal-shana (the portal of portals)
- monofurx (patched version of the original monofur)

### Shells:
- pwn (all the package needed for a ctf)
- cpp (developement in c++)
- java (jdk 17 env)

If you want to use this packages in your config:
```
inputs.nixos-samu.url = "github:SamueleFacenda/nixos-config";
# only if you understand what you are doing
# inputs.nixos-samu.inputs.nixpkgs.follows = "nixpkgs";

# configuration.nix

{inputs, pkgs, ...}: {
  xdg.portal.extraPortals = with pkgs; [
    inputs.nixos-samu.packages."${pkgs.system}".xdg-desktop-portal-shana
  ];
  
  font.packages = [
    inputs.nixos-samu.packages."${pkgs.system}".monofurx
  ];
}

```

### Configuration
My nixos configuration. It aim to work well under the hood and also be good to see. 
I use flakes instead of the standard configuration.nix
and home manager to configure my programs and desktop.

My goal is to have a good looking hyprland config.
 
TODOS:
- [ ] sway
- [x] zsh
- [x] powerlevel10k
- [ ] neovim + copilot
- [ ] secure boot
- [x] surface kernel
- [x] IPTS (surface pen)
- [ ] ~~libwacom overlay~~
- [x] fonts
- [x] cache cleanup
- [ ] rice :construction:
- [x] wallaper(s)
- [x] wakatime
- [x] cli trash bin with clean up
- [x] spotify with spicetify
- [x] ranger with kitty image preview
- [ ] hyprland :construction:
- [x] agenix
- [x] dev and pwn shells
- [x] kitty
- [x] remote build with nixbuild.net
- [ ] home server containers
- [ ] wofi :construction:
- [ ] waybar :construction:
- [ ] dunst :construction:
- [x] xdg-desktop-portal-shana
- [x] known nets
- [x] hyprland gnome indipendence
- [ ] tablet mode
- [ ] power profiles daemon
- [ ] remap surface pen button
- [x] wpa supplicant config
- [ ] nordic like theme (blue dark)
- [ ] make suspend, screen off and sleep work
- [ ] stylix
- [ ] phone integration (kde connect)
- [ ] waydroid
- [ ] more custom kernel (I already have to build it from source)
- [x] kanshi dynamic monitor config
- [ ] nixd language server

:construction: means work in progress


### Overlays (custom packages and other):
- hyprgrass (use hyprland from nixpkgs instead of the hyprland.org flake)
- micro-wakatime (faster loading)
- nerdfonts (use monofur with patched bullet point)
- rpl (update version)
- xdg-desktop-point-shana (new pkg)
- monofurx (new pkg)
