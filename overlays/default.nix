inputs: {
  # Overlays for personal pkgs (callPackage)
  additions = final: _: import ../pkgs { pkgs = final; };

    # Overlays is the list of overlays we want to apply from flake inputs.
    # overlays = [
    #   # inputs.neovim-nightly.overlays.default
    #   inputs.rofi-music-rs.overlays.default
    #   inputs.lsleases.overlays.default
    #   # inputs.yazi.overlays.default
    #
    #   (final: prev: {
    #     annotator =
    #       prev.callPackage ./pkgs/annotator
    #       {}; # path containing default.nix
    #     uvtools =
    #       prev.callPackage ./pkgs/uvtools {}; # path containing default.nix
    #     # hyprland = inputs.hyprland.packages."x86_64-linux".hyprland;
    #     # qemu = prev.qemu.override {smbdSupport = true;};
    #     # networkmanager-openconnect = prev.networkmanager-openconnect.overrideAttrs (old: rec {
    #     #   patches = old.patches ++ [./pkgs/networkmanager-openconnect/ip.patch];
    #     # });
    #     icecream = prev.icecream.overrideAttrs (old: rec {
    #       version = "1.4";
    #       src = prev.fetchFromGitHub {
    #         owner = "icecc";
    #         repo = old.pname;
    #         rev = "cd74801e0fa4e83e3ae254ca1d7fe98642f36b89";
    #         sha256 = "sha256-nBdUbWNmTxKpkgFM3qbooNQISItt5eNKtnnzpBGVbd4=";
    #       };
    #       nativeBuildInputs = old.nativeBuildInputs ++ [prev.pkg-config];
    #     });
    #     # walker = inputs.walker.packages."x86_64-linux".walker;
    #     waybar = inputs.waybar.packages."x86_64-linux".waybar;
    #   })
    #   # inputs.hyprland.overlays.default
    #   # inputs.hypridle.overlays.default
    #   # inputs.hyprlang.overlays.default
    #   # inputs.hyprpicker.overlays.default
    #   # inputs.hyprlock.overlays.default
    # ];
  # Overlays for various pkgs (e.g. broken / too old)
  # modifications = final: prev: {
  #   stable = import inputs.nixpkgs-stable {
  #     inherit (final) system;
  #     config.allowUnfree = true; # Forgive me Stallman
  #   };
  #
  #   # waybar = prev.waybar.overrideAttrs (oldAttrs: {
  #   #   mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
  #   # });
  #
  #   rofi-emoji-wayland = prev.rofi-emoji.overrideAttrs (_oldAttrs: {
  #     buildInputs = with final; [
  #       rofi-wayland-unwrapped
  #       cairo
  #       glib
  #       libnotify
  #       wl-clipboard
  #       xclip
  #       xsel
  #     ];
  #   });
  #
  #   tdlib = prev.tdlib.overrideAttrs (_oldAttrs: {
  #     version = "1.8.29";
  #     src = final.fetchFromGitHub {
  #       owner = "tdlib";
  #       repo = "td";
  #
  #       # The tdlib authors do not set tags for minor versions, but
  #       # external programs depending on tdlib constrain the minor
  #       # version, hence we set a specific commit with a known version.
  #       rev = "e4796b9bb67dee92d821f1c15e0f263a0941be13";
  #       sha256 = "07g0wa97w6gw5b04zb27jysradsi9gpksqlw5vrl9g5snl3ys8si";
  #     };
  #   });
  #
  #   mpv-visualizer = prev.mpvScripts.visualizer.overrideAttrs (_oldAttrs: {
  #     patches = [ ./patches/visualizer.patch ];
  #   });
  # };

  # # TODO: Analize
  # # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # # be accessible through 'pkgs.unstable'
  # unstable-packages = final: _prev: {
  #   unstable = import inputs.nixpkgs-unstable {
  #     inherit (final) system;
  #     config.allowUnfree = true;
  #   };
  # };
}
