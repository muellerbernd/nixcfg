{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    settings = let
      rofi-script = pkgs.writeShellScriptBin "rofi-script" ''
        rofi -modi "window,run,drun,combi" -combi-modi "window#drun#run" -show combi -lines 20 -show-icons
      '';
    in {
      env = lib.mapAttrsToList (name: value: "${name},${toString value}") {
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = 1;
        WLR_DRM_NO_ATOMIC = 1;
        XCURSOR_SIZE = 24;
        CLUTTER_BACKEND = "wayland";
        XDG_SESSION_TYPE = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        MOZ_ENABLE_WAYLAND = "1";
        # WLR_BACKEND = "vulkan";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1";
      };

      bezier = [
        "mycurve,.32,.97,.53,.98"
        "easeInOut,.5,0,.5,1"
        "overshot,.32,.97,.37,1.16"
        "easeInOut,.5,0,.5,1"
      ];
      decoration = {
        rounding = 0;
        drop_shadow = 1;
        shadow_range = 20;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";
        shadow_offset = "0 0";
        blur = {
          enabled = 1;
          size = 4;
          passes = 4;
          ignore_opacity = 1;
          xray = 1;
          new_optimizations = 1;
          noise = 0.03;
          contrast = 1.0;
        };
      };
      animations = {
        enabled = 1;
        animation = [
          "windowsMove,1,4,overshot"
          "windowsIn,1,3,mycurve"
          "windowsOut,1,10,mycurve,slide"
          "fadeIn,1,3,mycurve"
          "fadeOut,1,3,mycurve"
          "border,1,5,mycurve"
          "workspaces,1,3,default,slide"
        ];
      };

      dwindle = {
        pseudotile = 0;
        force_split = 2;
        preserve_split = 1;
        default_split_ratio = 1.3;
      };

      master = {
        new_is_master = false;
        new_on_top = false;
        no_gaps_when_only = false;
        orientation = "top";
        mfact = 0.6;
        always_center_master = false;
      };

      monitor = ["eDP-1,1920x1080@60,0x0,1"];

      misc = {
        vfr = true;
        # enable_swallow = true;
        # swallow_regex = "^(foot)$";
        animate_manual_resizes = false;
        force_default_wallpaper = 0;
      };

      input = {
        follow_mouse = 1;
        force_no_accel = 1;
        repeat_delay = 200;
        repeat_rate = 40;

        touchpad = {
          natural_scroll = true;
          # tap_to_click = 1;
          # disable_while_typing = 1;
          # clickfinger_behavior = 1;
          # middle_button_emulation = false;
        };

        kb_layout = "de";
      };

      general = {
        sensitivity = 0.2;

        gaps_in = 1;
        gaps_out = 4;
        border_size = 1;
        allow_tearing = true;

        layout = "dwindle";
      };
      binds = {
        workspace_back_and_forth = 0;
        allow_workspace_cycles = 1;
      };

      "$mod" = "SUPER";
      "$movemouse" = "sh -c 'eval `xdotool getactivewindow getwindowgeometry --shell`; xdotool mousemove $((X+WIDTH-80)) $((Y+120))'";
      "$terminal" = "wezterm";
      "$menu" = "${rofi-script}/bin/rofi-script";
      # "$menu" = "wofi --show drun";
      "$locker" = "~/scripts/lock_sway.sh";

      bind = [
        "$mod SHIFT,Q,killactive"
        "$mod,Period,exec,dunstctl close"
        #
        "$mod, RETURN, exec, $terminal"
        "$mod SHIFT, C, exec, hyprctl reload"
        "$mod, Q, exec, $terminal"
        "$mod, P, pseudo" # dwindle
        "$mod, J, togglesplit" # dwindle
        "$mod, D, exec, $menu"
        "$mod, Escape, exec, $locker"
        "$mod SHIFT, E, exec, sh ~/scripts/check-dotfiles.sh && ~/.config/rofi/scripts/powermenu/run.sh"

        "$mod, Space, togglefloating"
        # scratchpad
        "$mod, Minus, togglespecialworkspace, magic"
        "$mod SHIFT, Minus, movetoworkspace, special:magic"
        # move focus
        "$mod,Left,movefocus,l"
        "$mod,Down,movefocus,d"
        "$mod,Up,movefocus,u"
        "$mod,Right,movefocus,r"

        #movewindow
        "$mod SHIFT,Left,movewindow,l"
        "$mod SHIFT,Down,movewindow,d"
        "$mod SHIFT,Up,movewindow,u"
        "$mod SHIFT,Right,movewindow,r"

        # go to workspace
        "$mod,1,workspace,1"
        "$mod,2,workspace,2"
        "$mod,3,workspace,3"
        "$mod,4,workspace,4"
        "$mod,5,workspace,5"
        "$mod,6,workspace,6"
        "$mod,7,workspace,7"
        "$mod,8,workspace,8"
        "$mod,9,workspace,9"
        "$mod,0,workspace,10"

        # move container to workspace
        "$mod SHIFT,1,movetoworkspace,1"
        "$mod SHIFT,2,movetoworkspace,2"
        "$mod SHIFT,3,movetoworkspace,3"
        "$mod SHIFT,4,movetoworkspace,4"
        "$mod SHIFT,5,movetoworkspace,5"
        "$mod SHIFT,6,movetoworkspace,6"
        "$mod SHIFT,7,movetoworkspace,7"
        "$mod SHIFT,8,movetoworkspace,8"
        "$mod SHIFT,9,movetoworkspace,9"
        "$mod SHIFT,0,movetoworkspace,10"
      ];
      binde = [
        # "ALTSHIFT,H,resizeactive,-150 0"
        # "ALTSHIFT,J,resizeactive,0 150"
        # "ALTSHIFT,K,resizeactive,0 -150"
        # "ALTSHIFT,L,resizeactive,150 0"

        ",XF86AudioRaiseVolume,exec,~/scripts/controlVolumePipewire.py up"
        ",XF86AudioLowerVolume,exec,~/scripts/controlVolumePipewire.py down"
        ",XF86AudioMute,exec,exec,~/scripts/controlVolumePipewire.py mute"

        ",XF86MonBrightnessUp,exec,light -A 1 && sh ~/scripts/notifyBrightness.sh"
        ",XF86MonBrightnessDown,exec,light -U 1 && sh ~/scripts/notifyBrightness.sh"
      ];
      exec-once = [
        ''
          exec swayidle -w \
              timeout 300 'notify-send -u critical -t 9000 "Locking Screen in 10 seconds"' \
              timeout 310 '~/scripts/lock_sway.sh' \
              idlehint 310 \
              timeout 500 'swaymsg "output * dpms off"'\
              resume 'swaymsg "output * dpms on"'
        ''
        "nm-applet --indicator"
        "waybar"
        "blueman-applet"
        "dunst"
        "xbindkeys"
        "~/scripts/check-dotfiles.sh"
      ];
    };
  };
}
