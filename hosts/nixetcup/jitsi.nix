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
    # nginx.enable = true;
    # jicofo.enable = true;
    # jibri.enable = false;
    prosody.enable = false;
    # videobridge.enable = true;
    config = {
      authdomain = jitsi_fqdn;
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
      enableLayerSuspension = false;
      useNewBandwidthAllocationStrategy = true;
      requireDisplayName = true;
      hosts = {
        domain = jitsi_fqdn;
        anonymousDomain = "guests.${jitsi_fqdn}";
      };
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = true;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
  networking.firewall.allowedTCPPorts = [5222 5223 5269 5270 5280 5290];

  # services.prosody = {
  #   group = "nginx";
  #   allowRegistration = true;
  #   virtualHosts = {
  #     "${jitsi_fqdn}" = {
  #       enabled = true;
  #       domain = "${jitsi_fqdn}";
  #       # extraConfig = ''
  #       #   authentication = "internal_hashed"
  #       # '';
  #     };
  #
  #     "guests.${jitsi_fqdn}" = {
  #       domain = "guests.${jitsi_fqdn}";
  #       enabled = true;
  #       extraConfig = ''
  #         authentication = "anonymous"
  #         c2s_require_encryption = false
  #       '';
  #     };
  #   };
  # };
  #
  # services.jicofo = {
  #   enable = true;
  #   config = {
  #     "org.jitsi.jicofo.auth.URL" = "XMPP:${jitsi_fqdn}";
  #   };
  # };
}
