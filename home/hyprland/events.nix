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

        focusedmonitor=$(hyprctl workspaces -j \
          | jq ".[] | select(.name == \"$WORKSPACENAME\") | .monitor")
          
        othersworkspaceid=$(hyprctl monitors -j \
          | jq ".[] | select(.name != $focusedmonitor) | .activeWorkspace.id")
          
        focusedworkspaceid=$(hyprctl monitors -j \
          | jq ".[] | select(.name == $focusedmonitor) | .activeWorkspace.id")
          
        # If it's trying to go to the 0 (before the first) block and return to the first
        if [[ $((focusedworkspaceid % 10)) == 0 ]]
        then
          hyprctl dispatch workspace r+1
          return 0
        fi
        
        # Same for the last
        if [[ $((focusedworkspaceid % 10)) == 9 ]]
        then
          hyprctl dispatch workspace r-1
          return 0
        fi

        hyprcommand=""

        while IFS= read -r monitorworkspaceid
        do
          hyprcommand+="dispatch workspace $((monitorworkspaceid / 10 * 10 + (focusedworkspaceid - 1) % 10 + 1)) ; "
        done <<< "$othersworkspaceid"

        prevcursorcoords=$(hyprctl cursorpos)
        hyprcommand+="dispatch movecursor $(tr -d ',' <<<$prevcursorcoords)"

        hyprctl --batch "$hyprcommand" >/dev/null
      '';
    };
  };
}
