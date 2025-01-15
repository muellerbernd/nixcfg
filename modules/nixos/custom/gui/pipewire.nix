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
    pulse.enable = false;
    wireplumber.enable = true;
  };
  services.pipewire.wireplumber.extraConfig = {
    # "wh-1000xm3-ldac-hq" = {
    #   "monitor.bluez.rules" = [
    #     {
    #       matches = [
    #         {
    #           # Match any bluetooth device with ids equal to that of a WH-1000XM3
    #           "device.name" = "~bluez_card.*";
    #           "device.product.id" = "0x0cd3";
    #           "device.vendor.id" = "usb:054c";
    #         }
    #       ];
    #       actions = {
    #         update-props = {
    #           # Set quality to high quality instead of the default of auto
    #           "bluez5.a2dp.ldac.quality" = "hq";
    #         };
    #       };
    #     }
    #   ];
    # };
    "alsa-disable" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink";
            }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink";
            }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink";
            }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink";
            }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink";
            }
            {
              "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink";
            }
          ];
          actions = {
            update-props = {
              "device.disabled" = true;
              "node.disabled" = true;
            };
          };
        }
      ];
    };
    # bluetoothEnhancements = {
    #   "monitor.bluez.properties" = {
    #     "bluez5.enable-sbc-xq" = true;
    #     "bluez5.enable-msbc" = true;
    #     "bluez5.enable-hw-volume" = true;
    #     "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
    #   };
    # };
  };
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true; ## If compatibility with 32-bit applications is desired.
  #
  environment.systemPackages = with pkgs; [
    pamixer
    # pavucontrol
    pwvucontrol
  ];
}
