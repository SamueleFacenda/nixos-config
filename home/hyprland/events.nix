{ config, pkgs, lib, ...}:
let 
  events = [ # cat file | grep '()' | tr -d "(){ " | sed 's/^/"/' | sed 's/$/"/'
    "workspace"
    "focusedmon"
    "activewindow"
    "activewindowv2"
    "fullscreen"
    "monitorremoved"
    "monitoradded"
    "createworkspace"
    "destroyworkspace"
    "moveworkspace"
    "activelayout"
    "openwindow"
    "closewindow"
    "movewindow"
    "windowtitle"
    "openlayer"
    "closelayer"
    "submap"
  ];
  
  cfg = config.services.hypr-shellevents; 

  hyprlandEventHandlers = pkgs.writeShellScript "hyprlandEventHandlers" (
    builtins.concatStringsSep
      "\n"
      (lib.attrsets.mapAttrsToList
        (name: value: ''
          event_${name}() {
          ${value}
          }
        '')
        cfg.callbacks)
  );
  hyprlandHandleEvents = pkgs.writeShellScript "hyprlandHandleEvents" ''
    ${pkgs.socat}/bin/socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
      EXEC:"${pkgs.hypr-shellevents}/bin/shellevents ${hyprlandEventHandlers}",nofork
  '';
  
in 
{
  config.wayland.windowManager.hyprland.settings.exec-once = lib.mkIf cfg.enable [
    "${hyprlandHandleEvents}"
  ];
  
  options.services.hypr-shellevents = {
    enable = lib.mkEnableOption "hypr-shellevents";
    callbacks = lib.attrsets.genAttrs events (name: lib.mkOption {
      default = ":";
      type = lib.types.str;
      description = ''
        Callback for ${name} hyprland event, more info 
        [here](https://github.com/hyprwm/contrib/blob/main/shellevents/shellevents_default.sh)
      '';
    });
  };
  
  
  config.services.hypr-shellevents = {
    enable = true;
    callbacks = {
      workspace = ''
        # WORKSPACENAME
        prevcursorcoords=$(hyprctl cursorpos)

        focusedmonitor=$(hyprctl workspaces -j \
          | jq ".[] | select(.name == \"$WORKSPACENAME\") | .monitor")
          
        othersworkspaceid=$(hyprctl monitors -j \
          | jq ".[] | select(.name != $focusedmonitor) | .activeWorkspace.id")
          
        focusedworkspaceid=$(hyprctl monitors -j \
          | jq ".[] | select(.name == $focusedmonitor) | .activeWorkspace.id")

        hyprcommand=""

        while IFS= read -r monitorworkspaceid
        do
          hyprcommand+="dispatch workspace $((monitorworkspaceid / 10 * 10 + (focusedworkspaceid - 1) % 10 + 1)) ; "
        done <<< "$othersworkspaceid"

        # Remove trailing semicolon
        hyprcommand+="dispatch movecursor $(tr -d ',' <<<$prevcursorcoords)"
        hyprctl --batch "$hyprcommand" >/dev/null
      '';
    };
  };
}
