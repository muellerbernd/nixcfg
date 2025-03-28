{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  jitsi_fqdn = "jitsi.muellerbernd.de";
in {
  services.jitsi-meet = {
    enable = true;
    hostName = jitsi_fqdn;
    nginx.enable = true;
    jicofo.enable = true;
    jibri.enable = false;
    prosody.enable = true;
    videobridge.enable = true;
    config = {
      p2p.enabled = false;
      startAudioOnly = true;
      openBridgeChannel = "websocket";
    };
    # config = {
    #   disableShowMoreStats = false;
    #   startWithAudioMuted = true;
    #   startWithVideoMuted = true;
    #   # startAudioOnly = true;
    #   # enableLayerSuspension = false;
    #   # liveStreamingEnabled = false;
    #   useNewBandwidthAllocationStrategy = true;
    #   requireDisplayName = true;
    #   defaultLang = "en";
    # };
    # interfaceConfig = {
    #   SHOW_JITSI_WATERMARK = true;
    #   SHOW_WATERMARK_FOR_GUESTS = false;
    # };
  };
  services.jitsi-videobridge = {
    openFirewall = true;
    colibriRestApi = true;
    config.videobridge = {
      ice = {
        tcp.port = 7777;
      };
      stats.transports = [
        {type = "muc";}
        {type = "colibri";}
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [5222 5223 5269 5270 5280 5290];

  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8043"
  ];
}
