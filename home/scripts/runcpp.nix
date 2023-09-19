{ config, pkgs, ... }: {
  home.file.".scripts/runcpp.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      RED='\033[0;31m'
      GREEN='\033[0;32m'
      NC='\033[0m' # No Color

      if [ 0 -ge $# ]
      then
        printf "$RED No argument provided$NC \n"
        exit 2
      fi

      if [ ! -f $1 ]
      then
        printf "$RED File $1 not exists$NC \n"
        exit 3
      fi

      out="/tmp/$(md5sum $1 | awk '{print $1}')"
      mkdir $out 2> /dev/null

      out="''${out}/out"

      if [ -e $out ]
      then
          printf "$GREEN File cached $NC \n\n"
      else
          g++ -o "$out" $1
          echo "$GREEN Out file is $out $NC \n\n"
          chmod +x "$out"
      fi

      $out
    '';
  };
}
