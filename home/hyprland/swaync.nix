{ config, pkgs, lib, ...}: {
  systemd.user.services.swaync.Unit.PartOf = lib.mkForce [ "hyprland-session.target" ];
  systemd.user.services.swaync.Unit.After = lib.mkForce [ "hyprland-session.target" ];
  
  # Enable blur on layers
  wayland.windowManager.hyprland.settings.layerrule = [
    "blur, swaync-control-center"
    "blur, swaync-notification-window"
    
    "ignorezero, swaync-notification-window"
    "ignorezero, swaync-control-center"
    
    # "ignorealpha 0.5, swaync-control-center"
    # "ignorealpha 0.5, swaync-notification-window"
  ];
  
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
    style = with config.lib.stylix.colors.withHashtag; ''
    @define-color base00 ${base00}; @define-color base01 ${base01};
    @define-color base02 ${base02}; @define-color base03 ${base03};
    @define-color base04 ${base04}; @define-color base05 ${base05};
    @define-color base06 ${base06}; @define-color base07 ${base07};

    @define-color base08 ${base08}; @define-color base09 ${base09};
    @define-color base0A ${base0A}; @define-color base0B ${base0B};
    @define-color base0C ${base0C}; @define-color base0D ${base0D};
    @define-color base0E ${base0E}; @define-color base0F ${base0F};
    
    progress,
    progressbar,
    trough {
      border: 1px solid @base0D;
    }
    
    trough {
      background: @base01;
    }
    
    .notification.low,
    .notification.normal {
      border: 1px solid @base0D;
    }
    
    .notification.low progress,
    .notification.normal progress {
      background: @base0F;
    }
    
    .notification.critical {
      border: 1px solid @base08;
    }
    
    .notification.critical progress {
      background: @base08;
    }
    
    .summary {
      color: @base05;
    }
    
    .body {
      color: @base06;
    }
    
    .time {
      color: @base06;
    }
    
    .notification-action {
      color: @base05;
      background: @base01;
      border: 1px solid @base0D;
    }
    
    .notification-action:hover {
      background: @base01;
      color: @base05;
    }
    
    .notification-action:active {
      background: @base0F;
      color: @base05;
    }
    
    .close-button {
      color: @base02;
      background: @base08;
    }
    
    .close-button:hover {
      background: lighter(@base08);
      color: lighter(@base02);
    }
    
    .close-button:active {
      background: @base08;
      color: @base00;
    }
    
    .notification-content {
      background: @base00;
      border: 1px solid @base0D;
    }
    
    .floating-notifications.background .notification-row .notification-background {
      background: transparent;
      color: @base05;
    }
    
    .notification-group .notification-group-buttons,
    .notification-group .notification-group-headers {
      color: @base05;
    }
    
    .notification-group .notification-group-headers .notification-group-icon {
      color: @base05;
    }
    
    .notification-group .notification-group-headers .notification-group-header {
      color: @base05;
    }
    
    .notification-group.collapsed .notification-row .notification {
      background: @base01;
    }
    
    .notification-group.collapsed:hover
      .notification-row:not(:only-child)
      .notification {
      background: @base01;
    }
    
    .control-center {
      background: alpha(@base00, 0.2);
      border: 1px solid @base0D;
      border-right-style: none;
      border-radius: 12px 0px 0px 12px;
      color: @base05;
    }
    
    .control-center .notification-row .notification-background {
      color: @base05;
    }
    
    .control-center .notification-row .notification-background:hover {
      background: @base00;
      color: @base05;
    }
    
    .control-center .notification-row .notification-background:active {
      background: @base0F;
      color: @base05;
    }
    
    .widget-title {
      color: @base05;
      margin: 0.5rem;
    }
    
    .widget-title > button {
      background: @base01;
      border: 1px solid @base0D;
      color: @base05;
    }
    
    .widget-title > button:hover {
      background: @base01;
    }
    
    .widget-dnd {
      color: @base05;
    }
    
    .widget-dnd > switch {
      background: @base01;
      border: 1px solid @base0D;
    }
    
    .widget-dnd > switch:hover {
      background: @base01;
    }
    
    .widget-dnd > switch:checked {
      background: @base0F;
    }
    
    .widget-dnd > switch slider {
      background: @base06;
    }
    
    .widget-mpris {
      color: @base05;
    }
    
    .widget-mpris .widget-mpris-player {
      background: @base01;
      border: 1px solid @base0D;
    }
    
    .widget-mpris .widget-mpris-player button:hover {
      background: @base01;
    }
    
    .widget-mpris .widget-mpris-player > box > button {
      border: 1px solid @base0D;
    }
    
    .widget-mpris .widget-mpris-player > box > button:hover {
      background: @base01;
      border: 1px solid @base0D;
    }
    '';
  };
}
