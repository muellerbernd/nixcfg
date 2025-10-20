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
  # A daily timer that triggers the restart service at 12:00
  systemd.timers.matterbridgeRestart = {
    enable = true;
    timerConfig = {
      # run daily at 12:00
      OnCalendar = "*-*-* 12:00:00 Europe/Berlin";
      Unit = "matterbridge.service"; # fire the restart service
      Persistent = true;
    };
  };
}
