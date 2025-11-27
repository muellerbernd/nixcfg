{
  pkgs,
  lib,
  config,
  ...
}:
{
  age.secrets.matterbridgeConfig = {
    file = ../../secrets/matterbridge.age;
    owner = "matterbridge";
    group = "matterbridge";
  };
  services.matterbridge = {
    enable = true;
    configPath = config.age.secrets.matterbridgeConfig.path;
    user = "matterbridge";
  };

  systemd.services.matterbridgeRestart = {
    enable = true;
    description = "restart matterbridge";
    serviceConfig = {
      ExecStart = "systemctl restart matterbridge.service";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # A daily timer that triggers the restart service at 12:00
  systemd.timers.matterbridgeRestart = {
    enable = true;
    timerConfig = {
      # run daily at 13:00
      OnCalendar = "*-*-* 12:22:00 Europe/Berlin";
      Unit = "matterbridgeRestart.service"; # fire the restart service
      Persistent = true;
    };
  };
}
