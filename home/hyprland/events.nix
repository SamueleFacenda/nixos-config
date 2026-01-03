{ config, pkgs, lib, ... }:
let
  events = [
    # cat file | grep '()' | tr -d "(){ " | sed 's/^event_/"/' | sed 's/$/"/'
    "workspace"
    "workspacev2"
    "focusedmon"
    "activewindow"
    "activewindowv2"
    "fullscreen"
    "monitorremoved"
    "monitoradded"
    "monitoraddedv2"
    "createworkspace"
    "createworkspacev2"
    "destroyworkspace"
    "destroyworkspacev2"
    "moveworkspace"
    "moveworkspacev2"
    "renameworkspace"
    "activespecial"
    "activelayout"
    "openwindow"
    "closewindow"
    "movewindow"
    "movewindowv2"
    "windowtitle"
    "openlayer"
    "closelayer"
    "submap"
    "changefloatingmode"
    "urgent"
    "minimize"
    "screencast"
    "togglegroup"
    "moveintogroup"
    "moveoutofgroup"
    "ignoregrouplock"
    "lockgroups"
    "configreloaded"
    "pin"
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
    ${pkgs.socat}/bin/socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
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
    callbacks =
      let
        n = config.wayland.windowManager.hyprland.maxNWorkspaces;
        nstr = builtins.toString n;
      in
      lib.trivial.throwIf
        (n < 3)
        "There must be at least 3 workspaces (two are unacessible)"
        {
          # openwindow = "check-hide-waybar";
          # closewindow = "check-hide-waybar";

          # TODO movewindow put windows back if they are put on the unaccessible workspaces
          # TODO use workspacev2 and get workspaceid
          workspace = ''
            # WORKSPACENAME

            focusedmonitor=$(hyprctl workspaces -j | jq ".[] | select(.name == \"$WORKSPACENAME\") | .monitor")
              
            othersworkspaceid=$(hyprctl monitors -j | jq ".[] | select(.name != $focusedmonitor) | .activeWorkspace.id")
              
            focusedworkspaceid=$(hyprctl monitors -j | jq ".[] | select(.name == $focusedmonitor) | .activeWorkspace.id")
              
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

          # Put windows back when they are thrown out of bounds
          movewindowv2 = ''
            if [[ $((WORKSPACEID % ${nstr})) == ${builtins.toString (n -1)} ]]
            then
              hyprctl dispatch movetoworkspacesilent \
                 "$((WORKSPACEID-1)),address:0x$WINDOWADDRESS"
              return 0
            fi
              
            if [[ $((WORKSPACEID % ${nstr})) == 0 ]]
            then
              hyprctl dispatch movetoworkspacesilent \ 
                "$((WORKSPACEID+1)),address:0x$WINDOWADDRESS"
              return 0
            fi
          '';
        };
  };
}
