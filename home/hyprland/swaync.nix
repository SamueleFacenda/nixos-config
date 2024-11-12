{ config, pkgs, lib, ...}: {
  systemd.user.services.swaync.Unit.PartOf = lib.mkForce [ "hyprland-session.target" ];
  systemd.user.services.swaync.Unit.After = lib.mkForce [ "hyprland-session.target" ];
  services.swaync = {
    enable = true;
    settings = {
      notification-inline-replies = true;
      timeout = 5;
      timeout-low = 3;
      widgets = [
        "inhibitors"
        "backlight"
        "backlight#KB"
        "volume"
        "mpris"
        "title"
        "dnd"
        "notifications"
      ];
      widget-config = {
        backlight = {
          label = "🔆  ";
          min = 10;
          device = "intel_backlight";
        };
        "backlight#KB" = {
          label = "󰌌  ";
          device = "asus::kbd_backlight";
          subsystem = "leds";
        };
        volume = {
          label = "  ";
        };
      };
    };
    style = ''
    '';
  };
}
