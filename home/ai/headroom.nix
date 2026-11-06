{ config, ... }:

{
  # Headroom context-optimization proxy. The headroom-opencode plugin
  # (opencode.nix) routes every OpenAI-wire provider's traffic through it
  # on 127.0.0.1:8787, preserving the original upstream per request.
  systemd.user.services.headroom-proxy = {
    Unit.Description = "Headroom context-optimization proxy";
    Service.ExecStart = "${config.ai.plugins.headroom}/bin/headroom proxy";
    Service.Restart = "on-failure";
    Service.RestartSec = "5s";
    Install.WantedBy = [ "default.target" ];
  };
}
