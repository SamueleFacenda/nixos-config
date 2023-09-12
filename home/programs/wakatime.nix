{ config, pkgs, lib, ... }:
let
  writeable = true;
in
if writeable
then {
  home.activation = {
    wakatimeCfg = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if test ! -f ''${HOME}/.wakatime.cfg; then
        $DRY_RUN_CMD printf "[settings]\napi_key = @wakatime-key@" > ''${HOME}/.wakatime.cfg
      fi
    '';
  };
}
else {
  home.file.".wakatime.cfg".text =
    ''
      [settings]
      api_key = @wakatime-key@
    '';
  home.file.".wakatime.cfg".force = true;
}
