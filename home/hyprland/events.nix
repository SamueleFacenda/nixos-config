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
  config.wayland.windowManager.hyprland.settings.exec = lib.mkIf cfg.enable [
    "pkill -f hyprlandHandleEvents; pkill -f hyprlandEventHandlers; ${hyprlandHandleEvents}"
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
  
  options.wayland.windowManager.hyprland.maxNWorkspaces = lib.mkOption {
    type = lib.types.int;
    default = 6;
    example = 10;
    description = ''
      Maximum number of workspaces, used by the multi monitor workspace script.
      The number does not considers the two unacessible workspaces, so input 3 (the minimum)
      to have one workspace.
    '';
  };
  
  
  config.services.hypr-shellevents = {
    enable = true;
    callbacks = {
      # openwindow = "check-hide-waybar";
      # closewindow = "check-hide-waybar";
      
      workspace = 
        let
          n = config.wayland.windowManager.hyprland.maxNWorkspaces;
          nstr = builtins.toString n;
        in 
        lib.trivial.throwIf 
          (n < 3)
          "There must be at least 3 workspaces (two are unacessible)"
          ''
          # WORKSPACENAME

          focusedmonitor=$(hyprctl workspaces -j \
            | jq ".[] | select(.name == \"$WORKSPACENAME\") | .monitor")
            
          othersworkspaceid=$(hyprctl monitors -j \
            | jq ".[] | select(.name != $focusedmonitor) | .activeWorkspace.id")
            
          focusedworkspaceid=$(hyprctl monitors -j \
            | jq ".[] | select(.name == $focusedmonitor) | .activeWorkspace.id")
            
          # If it's trying to go to the 0 (before the first) block and return to the first
          if [[ $((focusedworkspaceid % ${nstr})) == 0 ]]
          then
            hyprctl dispatch workspace r+1
            return 0
          fi
          
          # Same for the last
          if [[ $((focusedworkspaceid % ${nstr})) == ${builtins.toString (n -1)} ]]
          then
            hyprctl dispatch workspace r-1
            return 0
          fi

          hyprcommand=""

          while IFS= read -r monitorworkspaceid
          do
            hyprcommand+="dispatch workspace $((monitorworkspaceid / ${nstr} * ${nstr} + (focusedworkspaceid - 1) % ${nstr} + 1)) ; "
          done <<< "$othersworkspaceid"

          prevcursorcoords=$(hyprctl cursorpos)
          hyprcommand+="dispatch movecursor $(tr -d ',' <<<$prevcursorcoords)"

          hyprctl --batch "$hyprcommand" >/dev/null
          
          # check-hide-waybar
          '';
    };
  };
}
