{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  home = {
    username = "root";
    packages = with pkgs; [
      neovim
      vim
      git
      git-lfs
      lazygit
      vcstool
      tmux
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    histSize = 10000;
    histFile = "${config.xdg.dataHome}/zsh/history";
  };

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
# vim: set ts=2 sw=2:
