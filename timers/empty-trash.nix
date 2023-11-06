{ config, pkgs, ... }: {
  systemd.timers."empty-trash" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "empty-trash.service";
      RandomizedDelaySec = "10min";
    };
  };

  systemd.services."empty-trash" = {
    script = "${pkgs.trashy}/bin/trashy empty --older-than 1month --force";
    serviceConfig = {
      Type = "oneshot";
      User = "samu";
    };
  };
}
