{ config, lib, pkgs, ... }: {
  # touch gestures
  wayland.windowManager.hyprland = {
    plugins = [ pkgs.hyprgrass ];
    settings.plugin.touch_gestures = {
      sensitivity = 6.0;
      workspace_swipe_fingers = 3;
    };
  };
}
