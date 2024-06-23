{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #       ["bluez5.enable-sbc-xq"] = true,
  #       ["bluez5.enable-msbc"] = true,
  #       ["bluez5.enable-hw-volume"] = true,
  #       ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #     }
  #   '';
  # };
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true; ## If compatibility with 32-bit applications is desired.
  #
  environment.systemPackages = with pkgs; [
    pamixer
    pavucontrol
  ];
}
