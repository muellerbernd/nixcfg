{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.jitsi-meet = {
    enable = true;
    hostName = "jitsi.muellerbernd.de";
    # nginx.enable = true;
    # jicofo.enable = true;
    # jibri.enable = false;
    # prosody.enable = true;
    # videobridge.enable = true;
    config = {
      authdomain = "jitsi-meet.muellerbernd";
      enableInsecureRoomNameWarning = true;
      fileRecordingsEnabled = false;
      liveStreamingEnabled = false;
      prejoinPageEnabled = true;
      enableWelcomePage = true;
      defaultLang = "en";
      # port = 8000;
      disableShowMoreStats = false;
      startWithAudioMuted = true;
      startWithVideoMuted = true;
      startAudioOnly = true;
      enableLayerSuspension = false;
      useNewBandwidthAllocationStrategy = true;
      requireDisplayName = true;
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = true;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
  networking.firewall.allowedTCPPorts = [5222 5223 5269 5270 5280 5290];
}
