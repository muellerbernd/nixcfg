{pkgs, ...}: {
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [{include = "~/.config/kanshi/myconfig";}];

    #   profiles = {
    #     # undocked = {
    #     #   outputs = [
    #     #     {
    #     #       criteria = "eDP-1";
    #     #       position = "0,0";
    #     #       scale = 1.0;
    #     #       status = "enable";
    #     #     }
    #     #   ];
    #     # };
    #     #
    #     # ilmspace = {
    #     #   outputs = [
    #     #     {
    #     #       criteria = "eDP-1";
    #     #       position = "0,0";
    #     #       scale = 1.0;
    #     #       status = "enable";
    #     #     }
    #     #     {
    #     #       criteria = "Sharp Corporation SHARP LCD 0x01010101";
    #     #       position = "1920,0";
    #     #       scale = 1.0;
    #     #       status = "enable";
    #     #     }
    #     #   ];
    #     #   # exec = "hyprctl keyword monitor desc:Sharp Corporation SHARP LCD 0x01010101,1920x1080@60,0x0,1,mirror,eDP-1";
    #     # };
    #     eis-undock = {
    #       outputs = [
    #         {
    #           criteria = "AU Optronics 0xD291";
    #           position = "0,0";
    #           mode = "1920x1200@60";
    #           scale = 1.0;
    #           status = "enable";
    #         }
    #       ];
    #     };
    #     eis-office = {
    #       outputs = [
    #         {
    #           criteria = "eDP-1";
    #           # criteria = "AU Optronics 0xD291";
    #           position = "0,0";
    #           mode = "1920x1200@60";
    #           scale = 1.0;
    #           status = "enable";
    #         }
    #         {
    #           criteria = "Dell Inc. DELL U2415 7MT018B3062L";
    #           position = "1920,0";
    #           scale = 1.0;
    #           status = "enable";
    #         }
    #         {
    #           criteria = "Dell Inc. DELL U2415 7MT0196C30JU";
    #           position = "3840,0";
    #           scale = 1.0;
    #           transform = "270";
    #           status = "enable";
    #         }
    #       ];
    #       exec = [
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspace 1 > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspaceopt persistent > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl keyword workspace 1,monitor:desc:Dell Inc. DELL U2415 7MT018B3062L > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl dispatch moveworkspacetomonitor 1 monitor:desc:Dell Inc. DELL U2415 7MT018B3062L > /dev/null"
    #
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspace 1 > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspaceopt persistent > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl keyword workspace 1,monitor:desc:Dell Inc. DELL U2415 7MT0196C30JU > /dev/null"
    #         "${pkgs.hyprland}/bin/ dispatch moveworkspacetomonitor 1 desc:Dell Inc. DELL U2415 7MT0196C30JU"
    #
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspace 3 > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl dispatch workspaceopt persistent > /dev/null"
    #         "${pkgs.hyprland}/bin/hyprctl keyword workspace 3,monitor:desc:AU Optronics 0xD291 > /dev/null"
    #         "${pkgs.hyprland}/bin/ dispatch moveworkspacetomonitor 3 monitor:desc:AU Optronics 0xD291 > /dev/null"
    #         "${pkgs.hyprland}/bin/ dispatch workspace -- 1"
    #       ];
    #     };
    #   };
  };
}
