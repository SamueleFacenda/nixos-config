# My nixos Flake:snowflake:

<!-- 
find ./ "" -type f 2>/dev/null | grep -v -E ".git|.png|.age|.jpg|.pem|.lock" | xargs cat | wc -l 
-->

![hyprland screenshot](assets/screenshot1.png)

This is more than my config, it's a flake. There are a couple packages and some devshells.
### Packages:
- xdg-desktop-portal-shana (the portal of portals)
- monofurx (patched version of the original monofur)
- libcamera-surface (see the file for credits, update to version 0.1.0)

### Shells:
- pwn (all the package needed for a ctf)
- cpp (developement in c++)
- java (jdk 17 env)

If you want to use that packages in your config:
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


### Note for surface devices

At the moment that I'm writing (2023 10 10) the porting to nixos of the surface kernel is not working.
I've made my own fork of nixos-hardware in order to fix it and I use it in my config. 
You can find in [here](https://github.com/SamueleFacenda/nixos-hardware)
 
 

TODOS:
- [x] zsh
- [x] powerlevel10k
- [ ] neovim + copilot
- [ ] secure boot
- [x] surface kernel
- [x] IPTS (surface pen)
- [x] ~~libwacom overlay~~
- [x] fonts
- [x] cache cleanup
- [ ] rice :construction:
- [x] wallaper(s)
- [x] wakatime
- [x] cli trash bin with clean up
- [x] spotify with spicetify
- [x] ranger with kitty image preview
- [x] hyprland
- [x] agenix
- [x] dev and pwn shells
- [x] kitty
- [x] remote build with nixbuild.net
- [ ] home server containers
- [x] waybar
- [ ] dunst
- [x] xdg-desktop-portal-shana
- [x] known nets
- [x] hyprland gnome indipendence
- [ ] tablet mode (hyprgrass)
- [x] power profiles daemon
- [ ] remap surface pen button
- [x] wpa supplicant config
- [x] nordic like theme (blue dark)
- [x] make suspend, screen off and sleep work
- [x] stylix
- [ ] phone integration (kde connect/gsconnects)
- [ ] waydroid
- [ ] more custom kernel (I already have to build it from source)
- [x] kanshi dynamic monitor config (crash on change, hyprland problem)
- [x] nixd language server
- [x] swayosd (on screen display)
- [ ] eww widgets
- [ ] flameshot
- [ ] hyprdim
- [ ] iio-hyprland
- [ ] nwg-drawer
- [ ] nwg-dock-hyprland
- [ ] hyprfocus
- [ ] libinput gestures
- [x] spotifyd, spotify-tui (need to be repaced with spotify-player)
- [x] flake templates
- [ ] waybar mpris, taskbar, drawers for brightness
- [ ] waycorner
- [ ] lid switch power off
- [x] adjust nixpkgs wayland overlay
- [ ] termfilechooser portal (with opque bg)

:construction: means work in progress


### Overlays (custom packages and other):
- hyprgrass (use hyprland from nixpkgs instead of the hyprland.org flake)
- micro-wakatime (faster loading)
- nerdfonts (use monofur with bullet point character from blexmono)
- rpl (update version)
- xdg-desktop-portal-shana (new pkg)
- monofurx (new pkg)
- libcamera-surface (new pkg)
