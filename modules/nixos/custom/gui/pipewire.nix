{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = lib.mkIf (config.services.pipewire.enable) {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    # rtkit is optional but recommended
    security.rtkit.enable = true;

    services.pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
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
    environment.systemPackages = with pkgs; [
      pamixer
      pavucontrol
      bluez # Bluetooth support
      bluez-tools # Bluetooth tools
    ];
  };
}
