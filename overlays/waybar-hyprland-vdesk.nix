final: prev: {
  waybar = prev.waybar.overrideAttrs {
    patchPhase = ''
      sed -i \
        -e 's/dispatch workspace name:/dispatch vdesk /g' \
        -e 's/dispatch workspace/dispatch vdesk/g' \
        -e 's#std::to_string(id())#std::to_string((int) ((id()-1) / gIPC->getSocket1JsonReply("monitors").size()) + 1)#g' \
        src/modules/hyprland/workspaces.cpp
    '';
  };
}
