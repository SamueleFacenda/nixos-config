{config, options, pkgs, lib,  ...}:
with lib;
let
  cfg = config.agenix.fill-placeholders;
  inherit (attrsets) mapAttrs;
in {
  options.agenix.fill-placeholders = mkOption {
    default = {};
    type = types.attrsOf types.string;
    description = "Replace all occurrence of @name@ in the specified file with the named secret";
    example = {
      wakatime-key = "/home/samu/.wakatime.cfg";
      my-secret = "/path/to/file/with/placeholder";	
    };
  };

  config.system.activationScripts = mapAttrs (name: value:
    ''
      secret=$(cat "${config.age.secrets."${name}".path}")
      configFile=${value}
      ${pkgs.gnused}/bin/sed -i "s#@${name}@#$secret#" "$configFile"
    ''
  ) cfg;
  
}
