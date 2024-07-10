{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = with inputs.self.nixosModules; [
    # modules
    mixins-locale
    mixins-fonts
  ];
  # NixOS uses NTFS-3G for NTFS support.
  boot.supportedFilesystems = ["ntfs" "cifs"];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  # Nix settings, auto cleanup and enable flakes
  nix = {
    package = pkgs.nixFlakes;
    settings.auto-optimise-store = true;
    settings.allowed-users = ["bernd" "nix-serve" "nixremote"];
    settings.trusted-users = ["root" "nixremote"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      builders-use-substitutes = true
    '';
  };

  environment.systemPackages = with pkgs; [
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    #
    gnupg
    pam_gnupg
    bc
    xbindkeys
    # nix
    home-manager
    # nix-serve
    # nix-serve-ng
    inputs.agenix.packages.${system}.default
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # programs

  # use zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  #
  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.tmux.enable = true;

  services = {
    logind.killUserProcesses = false;
    gnome.gnome-keyring.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = lib.mkDefault true;
      settings.X11Forwarding = lib.mkDefault true;
      # require public key authentication for better security
      settings.PasswordAuthentication = lib.mkDefault false;
      settings.KbdInteractiveAuthentication = lib.mkDefault false;
      settings.PermitRootLogin = lib.mkDefault "yes";
      openFirewall = lib.mkDefault true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      # for a WiFi printer
      openFirewall = true;
    };
  };
  security.polkit.enable = true;
}
