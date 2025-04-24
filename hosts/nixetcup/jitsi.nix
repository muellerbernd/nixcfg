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
    prosody.lockdown = true;
    # config = {
    #   enableWelcomePage = false;
    #   prejoinPageEnabled = true;
    #   defaultLang = "en";
    # };
    # interfaceConfig = {
    #   SHOW_JITSI_WATERMARK = false;
    #   SHOW_WATERMARK_FOR_GUESTS = false;
    # };
  };
  services.jitsi-videobridge = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  # services.jitsi-meet = {
  #   enable = true;
  #   hostName = jitsi_fqdn;
  #   nginx.enable = true;
  #   jicofo.enable = true;
  #   prosody.enable = true;
  #   videobridge.enable = true;
  #   config = {
  #     p2p.enabled = false;
  #     startAudioOnly = true;
  #     openBridgeChannel = "websocket";
  #   };
  #   # config = {
  #   #   disableShowMoreStats = false;
  #   #   startWithAudioMuted = true;
  #   #   startWithVideoMuted = true;
  #   #   # startAudioOnly = true;
  #   #   # enableLayerSuspension = false;
  #   #   # liveStreamingEnabled = false;
  #   #   useNewBandwidthAllocationStrategy = true;
  #   #   requireDisplayName = true;
  #   #   defaultLang = "en";
  #   # };
  #   # interfaceConfig = {
  #   #   SHOW_JITSI_WATERMARK = true;
  #   #   SHOW_WATERMARK_FOR_GUESTS = false;
  #   # };
  # };
  # services.jitsi-videobridge = {
  #   openFirewall = true;
  #   colibriRestApi = true;
  #   config.videobridge = {
  #     ice = {
  #       tcp.port = 7777;
  #     };
  #     stats.transports = [
  #       {type = "muc";}
  #       {type = "colibri";}
  #     ];
  #   };
  # };
  # systemd.services = lib.genAttrs ["jicofo" "jitsi-meet-init-secrets" "jitsi-videobridge2" "prosody"] (_: {
  #   serviceConfig = {
  #     Slice = "communications.slice";
  #   };
  # });
  boot.kernel.sysctl."net.core.rmem_max" = lib.mkForce 10485760;
  # networking.firewall.allowedTCPPorts = [5222 5223 5269 5270 5280 5290];

  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8043"
  ];
}
