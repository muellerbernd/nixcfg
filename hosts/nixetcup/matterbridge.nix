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
}
