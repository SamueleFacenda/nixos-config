{ config, pkgs, lib, secrets, ... }:
let
  format = pkgs.formats.ini { };
in
{
  home.file.".wakatime.cfg".source = format.generate ".wakatime.cfg" {
    settings = {
      api_key_vault_cmd = "cat ${secrets.wakatime-key.path}";
      api_url = "https://wakapi.dev/api";
    };
  };
  home.file.".wakatime.cfg".force = true;
}
