{ ... }:
{
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";

    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            scale = 1.0;
            status = "enable";
          }
        ];
      };

      ilmspace = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "0,0";
            scale = 1.0;
            status = "enable";
          }
          {
            criteria = "Sharp Corporation SHARP LCD 0x01010101";
            position = "1920,0";
            scale = 1.0;
            status = "enable";
          }
        ];
        # exec = "hyprctl keyword monitor desc:Sharp Corporation SHARP LCD 0x01010101,1920x1080@60,0x0,1,mirror,eDP-1";
      };
    };
  };
}

