{
  pkgs,
  config,
  lib,
  ...
}: {
  services.pcscd.enable = true;
  services.pcscd.plugins = [pkgs.acsccid pkgs.ccid pkgs.libacr38u pkgs.scmccid];
  environment.systemPackages = with pkgs; [
    #
    pcsc-tools
    p11-kit
    gnutls
    opensc
  ];
  # Tell p11-kit to load/proxy opensc-pkcs11.so, providing all available slots
  # (PIN1 for authentication/decryption, PIN2 for signing).
  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';
  programs.firefox.nativeMessagingHosts.euwebid = true;
  programs.firefox.policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
}
