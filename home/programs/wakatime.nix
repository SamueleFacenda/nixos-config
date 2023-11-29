{ config, pkgs, lib, ... }:
let
  writeable = true;
  toml = pkgs.formats.toml { };
in
if writeable
then {
  home.activation = {
    wakatimeCfg = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD printf "[settings]\napi_key = @wakatime-key@\napi_url = https://wakapi.dev/api" > ''${HOME}/.wakatime.cfg
    '';
  };
}
else {
  home.file.".wakatime.cfg".source = toml.generate ".wakatime.cfg" {
    settings.api_key = "@wakatime-key@";
    settings.api_url = "https://wakapi.dev/api";
  };
  home.file.".wakatime.cfg".force = true;
}
