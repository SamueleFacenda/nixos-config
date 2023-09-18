{ config, pkgs, ... }: {
  home.file.".scripts/sleep.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      swayidle -w timeout 300 'swaylock -f --screenshot --effect-blur 10x7 --fade-in 5' \
                  timeout 600 'hyprctl dispatch dpms off' \
                  resume 'hyprctl dispatch dpms on' \
                  timeout 900 'systemctl suspend' \
                  resume 'hyprctl dispatch dpms on' \
                  after-resume 'hyprctl dispatch dpms on' \
                  before-sleep 'swaylock -f --screenshot --effect-blur 10x7 --fade-in 5' &
    '';
  };
}
