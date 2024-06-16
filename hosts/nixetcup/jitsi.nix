{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  services.jitsi-meet = {
    enable = true;
    hostName = "meet.muellerbernd.de";
    nginx.enable = true;
    jicofo.enable = true;
    jibri.enable = false;
    prosody.enable = true;
    videobridge.enable = true;
    config = {
      enableWelcomePage = true;
      prejoinPageEnabled = true;
      defaultLang = "en";
      # port = 8000;
      disableShowMoreStats = false;
      startWithAudioMuted = true;
      startWithVideoMuted = true;
      startAudioOnly = true;
      enableLayerSuspension = false;
      liveStreamingEnabled = false;
      useNewBandwidthAllocationStrategy = true;
      requireDisplayName = true;
    };
    #   interfaceConfig = {
    #     SHOW_JITSI_WATERMARK = true;
    #     SHOW_WATERMARK_FOR_GUESTS = false;
    #   };
  };
  services.jitsi-videobridge.openFirewall = true;
}
