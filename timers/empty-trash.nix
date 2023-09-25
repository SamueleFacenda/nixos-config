{ config, pkgs, ... }: {
  systemd.timers."empty-trash" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
      Unit = "empty-trash.service";
      RandomizedDelaySec = "10min";
    };
  };

  systemd.services."empty-trash" = {
    script = "${pkgs.trashy}/bin/trash empty --older-than 1week --force";
    serviceConfig = {
      Type = "oneshot";
      User = "samu";
    };
  };
}
