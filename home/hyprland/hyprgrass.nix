{ config, lib, pkgs, ... }: {
  # touch gestures
  wayland.windowManager.hyprland = {
    plugins = [ pkgs.hyprlandPlugins.hyprgrass ];
    # review at first login: plugin config path in Lua (plugin:touch_gestures:*) is inferred
    settings.config.plugin.touch_gestures = {
      sensitivity = 6.0;
      workspace_swipe_fingers = 3;
    };
  };
}
