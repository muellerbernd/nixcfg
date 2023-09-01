{ config, pkgs, lib, ... }: {
  fonts.enableDefaultFonts = true;
  fonts.fonts = with pkgs; [
    #    corefonts
    fira-code
    fira-code-symbols
    terminus_font
    jetbrains-mono
    powerline-fonts
    gelasio
    nerdfonts
    iosevka
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    ttf_bitstream_vera
    terminus_font_ttf
  ];
}
# fonts = {
#   fonts = with pkgs; [
#     (nerdfonts.override {
#       fonts = [
#         "FiraCode"
#         "DroidSansMono"
#         "Hack"
#         # "Iosevka"
#       ];
#     })
#     noto-fonts
#     noto-fonts-cjk
#     noto-fonts-emoji
#     liberation_ttf
#     fira-code
#     fira-code-symbols
#     mplus-outline-fonts.githubRelease
#     dina-font
#     proggyfonts
#   ];
#   fontconfig = {
#     hinting.autohint = true;
#     defaultFonts = { emoji = [ "OpenMoji Color" ]; };
#   };
# };
# vim: set ts=2 sw=2:
