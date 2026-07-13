{ config, pkgs, lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  mod = "SUPER";

  # hl.bind(keys, dispatcher [, opts]). `disp` is a Lua expression string.
  # In Lua every old bind* family (bind/bindr/bindm/bindl/bindle) is a single
  # hl.bind call; the trailing flags become the opts table.
  bind = keys: disp: { _args = [ keys (lua disp) ]; };
  bindWith = opts: keys: disp: { _args = [ keys (lua disp) opts ]; };
  release = bindWith { release = true; }; # bindr
  locked = bindWith { locked = true; }; # bindl
  lockedRepeat = bindWith { locked = true; repeating = true; }; # bindle

  # dispatcher builders (return Lua expression strings)
  exec = cmd: "hl.dsp.exec_cmd([[${cmd}]])";
  focusDir = d: ''hl.dsp.focus({ direction = "${d}" })'';
  focusWs = ws: ''hl.dsp.focus({ workspace = "${ws}" })'';
  moveWs = ws: ''hl.dsp.window.move({ workspace = "${ws}" })'';
  moveMon = m: ''hl.dsp.window.move({ monitor = "${m}" })'';
in
{
  wayland.windowManager.hyprland.settings =
    let
      keyboard = "wvkbd-mobintl";
      flags = "--landscape-layers simple,special,emoji -L 200 ";
    in
    {

      gesture = [
        { fingers = 3; direction = "horizontal"; action = "workspace"; }
        # hl.gesture actions are a fixed string set (workspace/move/resize/...); an arbitrary
        # command is run by passing `action` as a Lua function (a CLuaFunctionGesture).
        { fingers = 3; direction = "vertical"; action = lua "function() hl.exec_cmd([[pkill -SIGUSR1 waybar]]) end"; }
      ];

      bind = [
        (bind "${mod} + Q" (exec "kitty"))
        (bind "${mod} + C" "hl.dsp.window.close()")
        (bind "${mod} + F" ''hl.dsp.window.float({ action = "toggle" })'')
        (bind "${mod} + M" "hl.dsp.exit()") # review: exit dispatcher may be restricted in 0.55 (migration note suggests uwsm stop)
        (bind "${mod} + B" (exec "sleep 1 && hyprctl dispatch 'hl.dsp.dpms({ action = \"off\" })'"))
        (bind "${mod} + space" (exec "echo keyboard_change")) # keyboard change, configured in settings (keep to prevent menu spawn)
        (bind "${mod} + S" ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'') # review: fullscreen mode name
        (bind "${mod} + W" (exec "pkill -SIGUSR1 waybar"))

        # Windows bindings (they are recorded on the mouse)
        (bind "CTRL + SUPER + left" (focusWs "r-1")) # review: relative workspace string r-1
        (bind "CTRL + SUPER + right" (focusWs "r+1"))

        #### windows navigation and arrangement ####
        # move window to another monitor  # review: monitor-direction move (mon:r/l/u/d)
        (bind "CTRL + SHIFT + L" (moveMon "r"))
        (bind "CTRL + SHIFT + H" (moveMon "l"))
        (bind "CTRL + SHIFT + J" (moveMon "d"))
        (bind "CTRL + SHIFT + K" (moveMon "u"))
        # focus a window in direction
        (bind "CTRL + L" (focusDir "right"))
        (bind "CTRL + H" (focusDir "left"))
        (bind "CTRL + J" (focusDir "down"))
        (bind "CTRL + K" (focusDir "up"))
        # Move window on virtual desktop
        (bind "${mod} + right" (moveWs "r+1")) # review: relative move-to-workspace r+1
        (bind "${mod} + left" (moveWs "r-1"))

        # bindr (on release)
        # review: SUPER + super_l release-bind key syntax
        (release "${mod} + super_l" (exec "toggle wofi --show drun"))

        # bindm (mouse) -> drag / resize dispatchers
        (bind "${mod} + mouse:272" "hl.dsp.window.drag()")
        (bind "${mod} + Control_L" "hl.dsp.window.drag()")
        (bind "${mod} + mouse:273" "hl.dsp.window.resize()")
        (bind "${mod} + ALT_L" "hl.dsp.window.resize()")

        # bindl (locked)
        # review: switch:off/on:Lid Switch bind key syntax
        (locked "switch:off:Lid Switch" (exec "hyprctl keyword monitor 'eDP-1,highres,0x0,2'"))
        (locked "switch:on:Lid Switch" (exec "clamshell-suspend"))
        # Allow hibernate (boot switch) while locked
        (locked "${mod} + Delete" (exec "pgrep hyprlock && systemctl hibernate"))
        (locked "XF86AudioMute" (exec "swayosd-client --output-volume mute-toggle"))
        (locked "XF86AudioPlay" (exec "playerctl play"))
        (locked "XF86AudioPause" (exec "playerctl pause"))
        (locked "XF86AudioStop" (exec "playerctl stop"))
        (locked "SUPER + SHIFT + S" (exec ''grim -g "$(slurp)"''))
        (locked "print" (exec "grim"))

        # bindle (locked + repeating)
        (lockedRepeat "XF86AudioRaiseVolume" (exec "swayosd-client --max-volume 150 --output-volume +5"))
        (lockedRepeat "XF86AudioLowerVolume" (exec "swayosd-client --max-volume 150 --output-volume -5"))
        (lockedRepeat "XF86MonBrightnessUp" (exec "swayosd-client --brightness +5"))
        (lockedRepeat "XF86MonBrightnessDown" (exec "swayosd-client --brightness -5"))
        (lockedRepeat "XF86AudioPrev" (exec "playerctl previous"))
        (lockedRepeat "XF86AudioNext" (exec "playerctl next"))
        (lockedRepeat "XF86AudioMicMute" (exec "pamixer --default-source -t"))

        # XF86TouchpadToggle XF86WebCam windows+p XF86Launch1 leftwindows+leftshift+s+XF86SelectiveScreenshot

        # For mic and camera buttons led toggle
        # $ sudo -s
        # $ cd /sys/kernel/debug/asus-nb-wmi
        # $ echo "0x00040017" > dev_id
        # $ echo "1" > ctrl_param
        # $ cat  devs
        # $ echo "0" > ctrl_param
        # $ cat  devs
        # $ echo "0x00060078" > dev_id
      ];
    };
}
