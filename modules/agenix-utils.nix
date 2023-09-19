{ config, options, pkgs, lib, ... }:
with lib;
let
  inherit (attrsets) mapAttrsToList;
  inherit (builtins) replaceStrings listToAttrs concatLists map;


  cfg = config.age.secrets;

  fillPlaceholdersOption = { name, config, ... }: {
    options.fillPlaceholdersFiles = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = "Replace all occurrence of @secret@ in the files with the secret value";
      example = [ "/path/to/file/with/placeholder" "/second/path/to/file/with/placeholder" ];
    };
  };

  scripts = listToAttrs
    # list of name-value couples of scripts
    (concatLists
      # map every secret to a list of name-value couples (one per file to replace)
      (mapAttrsToList
        # map every file path to a name-value couple
        (secret: v:
          map
            (path: {
              name = "${secret}${replaceStrings ["/" "."] ["-" ""] path}";
              value = ''
                secret=$(cat "${config.age.secrets."${secret}".path}")
                configFile=${path}
                ${pkgs.gnused}/bin/sed -i "s#@${secret}@#$secret#" "$configFile"
              '';
            })
            v.fillPlaceholdersFiles)
        cfg));

in
{
  options.age.secrets = mkOption {
    type = types.attrsOf (types.submodule fillPlaceholdersOption);
  };

  config.system.activationScripts = scripts;
}
