# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    ../default.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.configurationLimit = 8;
    };
  };

  # systemd = {
  #   services.nvidia-control-devices = {
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig.ExecStart =
  #       "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
  #   };
  # };

  networking.hostName = "biltower"; # Define your hostname.

  # nvidia setup
  services.xserver.videoDrivers = [ "nvidia" ];
  # try to fix tearing
  # services.xserver.screenSection = ''
  #   Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
  # '';

  hardware = {
    # enable opengl
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = true;
    bluetooth.enable = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    nvidia = {
      # Modesetting is needed most of the time
      modesetting.enable = true;

      # Enable power management (do not disable this unless you have a reason to).
      # Likely to cause problems on laptops and with screen tearing if disabled.
      powerManagement.enable = true;

      # Use the NVidia open source kernel module (which isn't “nouveau”).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      #Fixes a glitch
      nvidiaPersistenced = true;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      # tearing
      forceFullCompositionPipeline = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance
    # nix
    nixpkgs-lint
    nixpkgs-fmt
    nixfmt
    #
    cudatoolkit
  ];

  # environment.pathsToLink =
  #   [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # icecream setup
  services = {
    icecream = {
      daemon = {
        enable = true;
        # hostname = "daemon-icecream-biltower";
        openFirewall = true;
        openBroadcast = true;
      };
      scheduler = {
        enable = true;
        # netName = "scheduler-icecream-biltower";
        openFirewall = true;
      };
    };
    # nix-serve setup
    nix-serve = {
      enable = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };
  };

  # nix = {
  #   sshServe = {
  #     protocol = "ssh-ng";
  #     enable = true;
  #     write = true;
  #     keys = [
  #       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1kobWixjrXRDr4017qV0PxX9+29Sw94o54B+BV6gcBug6q6UnE5cVXB6Se3Yw5dBV0Cw0zGJ6IBCEp2jT4HrVzhLb5Qw59pgaXj7YFkqnRv2Srnp0QHp3GewbKveM9mTxn8NVjlE/d3jMjOlKDW32eRo1hhL3d3RWxIRYSzd9GNaU9029bPWmsUTwsGqF4qr0jASD6ktJENgLwSI+Gk8AbjZnqRNXZzIN+lfQ4Hg4GusuvtCfDAMhILNpATuWoTo7P2K+8TBRQ4uJ+vzjsXWw+zf7BvQSrpv6r54Zku5YZMqnsdXNdpsDfhWoABXKiiHBXd10stFBqhh24PlUpEq+kOe8DeC5o/xRK5xMnGj59ciEQip7Se/Lcfa+nj1zbXImaSn9Xp9jt8RnlovIve6ExRmc1LzPo248mEANzyWkesGW7dMuYZkCAVep/JZuc33TBd27dd6kkQq73EDRC6TSccpsaIinU+zTyF/0Itz2LllC9tNeqo+d1GnK4Sf85xk= bernd@home-t480"
  #     ];
  #   };
  # };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # eis-remote
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6 bernd@t480ilmpad"
      #ilmpad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr7tntTSMnedzhPA9ScXtX5JtRlsqQEqZisSXV/gs9Z7eDOrFiLZFVCZ7M+z9U4TvXCkEw1r06ruLcYHim5wSSLhW7tHpFm7fs1CA9gbftbUkKHx8Po+f6tA9J+f60gQHJeG2KPaYzjeBMIc4e+4E4jj0d+zzGUrKTcNu6fMZUT+dA1TR4+sCH5eTi476avLdbAcgYUWnuUJCXixFjjhdalIClcZGFnNFXz3CZfnPiE5tBitAMZJjc4Nkz14PyTQvDH7OSkqQvlBZ8L56SvZSX9ZxEbClgeVUEVI63QYIVjEgeOB4xFr0dpIlPlwAhaBsakr7hmvHpllvMgerUC61Et6T3PWmNO+uAyv0UBcWQG1lMXLlfnN4NfYMoun69kmM/t0KkhT6w2sHjBpuzaoz/0YZSniTOv/Ov5igK/OOwAcshXV0n9Tf31oPqe1UaI6CtyT1qrWgnvxTkTRlxT80g+Ky99BCCCE5BKvFrlq3UziMrRo3NNJ3q/diBhwcvDbc= bernd@t480i7"
      # handy
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmVutzPV7bDLbyorV+kK4xQ6usfYzxHdT/M76iQ3bgcVHdtAMPN/5hOnvCj5NwEiUn2k7W5WKHrwKYOdYvDHPohMi/y2j0ZXvLrRIOFfKfAmHQWJkjC527N8xUBrM+qBl/oHpjTCGS4Ia7lY7ADZBKvpEHyQ/prdVMa+pmChQHFiALEipoHBjsM8A984hRVI7bzvBkzO0mVo0TAylsr9xxMqjROqtZHNIb2dMPgx4Lbx3uFHKN8yQLT8Yhjx3ViVp4jgcMdSYtvK0i+xXsl6KwDH3g9HM921ZHE+gbA02vOmm0zXQJmiqW+pwuP3iQigxWsK/3FYI45jpaltmsJHg9"
      #bernd lenovo x240 key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/XkOH/IXFjWKWj3RUXP44MHH9P551VeA37MXhl/FeTcitQEomTQzOld6sMzbfca0I0IID25HsXEVEwohp6cHB1sU/YecTu70Ya29r1uqnCmZsnipiNYIAvf8B7GYZZrsWMRn582Cj0vL0zWr5x4SaTydPEifurzUM8DUQLMuN3i1o8yBaUCnqQbjyTec07EpRl15qysWLRW/fg4+fw+V4u91E8X+fUCH63H4pAGRKuXybMlA9q5IDuvTAdlcXi3CiTVp7WKWo0rwkTgzNvvLG7gSyoZu0VCoXW0yTaGjCPg7k7vUsSpUutiIKo8TG1rtEOBS/efzVWc0j1bbBWl2Tgu6JfjYwGfHt//URPvoy4TMJLjoxQ1t3HoiBGhVvSpDeqSD1N2WeutSmArfdlHa0D3hy5lF/uOlEaUhxxxlOOy4F6EPo25JpAiny+UxMuABiH/YmqfuGfJ+TMbZyO9N7ePJuCH/GafLxNjb64yS9ogTGipanb3lQfi+X2zp7ZUU= bernd@x240"
      # bernd lenovo t480 key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1kobWixjrXRDr4017qV0PxX9+29Sw94o54B+BV6gcBug6q6UnE5cVXB6Se3Yw5dBV0Cw0zGJ6IBCEp2jT4HrVzhLb5Qw59pgaXj7YFkqnRv2Srnp0QHp3GewbKveM9mTxn8NVjlE/d3jMjOlKDW32eRo1hhL3d3RWxIRYSzd9GNaU9029bPWmsUTwsGqF4qr0jASD6ktJENgLwSI+Gk8AbjZnqRNXZzIN+lfQ4Hg4GusuvtCfDAMhILNpATuWoTo7P2K+8TBRQ4uJ+vzjsXWw+zf7BvQSrpv6r54Zku5YZMqnsdXNdpsDfhWoABXKiiHBXd10stFBqhh24PlUpEq+kOe8DeC5o/xRK5xMnGj59ciEQip7Se/Lcfa+nj1zbXImaSn9Xp9jt8RnlovIve6ExRmc1LzPo248mEANzyWkesGW7dMuYZkCAVep/JZuc33TBd27dd6kkQq73EDRC6TSccpsaIinU+zTyF/0Itz2LllC9tNeqo+d1GnK4Sf85xk= bernd@home-t480"
      # p14s work
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKZ62DjNQHx4q9VLpjMAby191PoKMdP2x+qZmmdCQgk/4s7/OhDTzYCzUZE5D6VgAN3Gg2uWnqQ5QezbevwOKf4ZGDQ/yJDFgGeYHmPLDvvdnb2KjPWznR+GQ8aqdCe4fCmR4uyViwrGCPY3vvGYJpubdmDH/xJS1orev6JeLovR65sq+OSTaTXE3tlHGOZKGJkAPrXc9rAATwUusNPDWuKXpGA4gaXqMFXdPYv11lJDcd7b7ApwSg8TuQmH99U+tiJLObjwVjW92QweyL3wemG0Ch5LF2ffAJXjyWDz9Atp/yle6NBRqwclFIVJQX5mHNwgL8HSrTsxr8t0FaPqqZ+tbirwfSqnaBnoLLoeHjtst2hQmodGrUaN2c7knnVHO5CxM04uiF4MMOwe3qrVf4TtN4bLtJqPW+73HtnYkMSUasRzwnpa/MWYIuU6fabZX3uXTIJxJIJ2POTsmXVj8oIEx4vQKOXlAAK/rWcu26ZwjtUXms2dV9v57xDcu8pG8= bernd@ros-p14s-linux"
      # woodserver
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+qvbVWlZRERjS1MohguRWZgq/r3+K8TRgp981RHtUop/LBjyzc4/bBM3q7dIu+6WatORZuk52Eu+quagYtU2OscYX5+j4djkC6s6/FzIkNITrnSQw3+K+M9wAYINfehu8AkojQ/l/6eIrPkxt4vtCBoVKo2BnV0K45klBCU29IhaJgibZ7L4wsKy4MltYAuQQaooyOJVWLlvseRYKCviZ1lPTD9Yy8Z3zKj5c8w3QK5RngozzgOWtX0+KjUWS4/fJWmp+jl7ijhS2kGqUNTgBGqMNAcZwdoggntDnESeBuaokefedJwcoAJfq38U/lnIvPL4ygRnIAYeFoIcu0fnB bernd@debian-wood-server"
    ];
  };
}

# vim: set ts=2 sw=2:
