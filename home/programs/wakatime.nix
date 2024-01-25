{ config, pkgs, lib, secrets, ... }:
let
  format = pkgs.formats.ini { };
in
{
  home.file.".wakatime.cfg".source = format.generate ".wakatime.cfg" {
    settings = {
      api_url = "https://wakapi.dev/api";
    } // (if secrets ? wakatime-key.path
    then { api_key_vault_cmd = "cat ${secrets.wakatime-key.path}"; }
    else { api_key = "placeholder"; });
  };
  home.file.".wakatime.cfg".force = true;
}
