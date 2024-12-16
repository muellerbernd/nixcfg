{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # fonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "DroidSansMono"
          "Hack"
          # "Iosevka"
        ];
      })
      fira-code
      fira-code-symbols
      terminus_font
      jetbrains-mono
      powerline-fonts
      gelasio
      # nerdfonts
      iosevka
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-code-pro
      ttf_bitstream_vera
      terminus_font_ttf
      babelstone-han
    ];
  };
}
