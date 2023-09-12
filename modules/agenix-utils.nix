{ config, options, pkgs, lib, ... }:
with lib;
let
  inherit (attrsets) mapAttrs filterAttrs nameValuePair mapAttrsToList;
  inherit (builtins) replaceStrings listToAttrs concatLists;


  cfg = config.age.secrets;

  fillPlaceholders = { name, config, ... }: {
    options.fillPlaceholdersFiles = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = "Replace all occurrence of @secret@ in the files with the secret value";
      example = [ "/path/to/file/with/placeholder" "/second/path/to/file/with/placeholder" ];
    };
  };


  genFlatScriptAttrset = set: listToAttrs (concatLists (mapAttrsToList genFromOptions set));

  genFromOptions = name: options: map (mkEntry name) options.fillPlaceholdersFiles;

  mkEntry = name: path: {
    name = "${name}${replaceStrings ["/" "."] ["-" ""] path}";
    value = makeScript name path;
  };

  makeScript = secretName: path: ''
    secret=$(cat "${config.age.secrets."${secretName}".path}")
    configFile=${path}
    ${pkgs.gnused}/bin/sed -i "s#@${secretName}@#$secret#" "$configFile"
  '';

in
{
  options.age.secrets = mkOption {
    type = types.attrsOf (types.submodule fillPlaceholders);
  };

  config.system.activationScripts = genFlatScriptAttrset cfg;
}
