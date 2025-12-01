{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code-symbols
      terminus_font
      jetbrains-mono
      powerline-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-code-pro
      ttf_bitstream_vera
      terminus_font_ttf
      babelstone-han
      font-awesome

      nerd-fonts.hack
      nerd-fonts.overpass
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.hasklug
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.noto
      nerd-fonts.ubuntu
      nerd-fonts.iosevka
      nerd-fonts.dejavu-sans-mono
    ];
    fontconfig = {
      defaultFonts = {
        # serif = ["JetBrains Mono Nerd Font"];
        # sansSerif = ["JetBrains Mono Nerd Font"];
        # monospace = ["JetBrains Mono Nerd Font Mono"];
        serif = [ "Hack Nerd Font" ];
        sansSerif = [ "Hack Nerd Font" ];
        monospace = [ "Hack Nerd Font Mono" ];
      };
    };
    fontconfig.useEmbeddedBitmaps = true;
  };
}
