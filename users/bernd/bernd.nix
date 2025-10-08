{
  config,
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "bernd" ];
  users.users.bernd = {
    isNormalUser = true;
    description = "Bernd Müller";
    extraGroups = [
      "adbusers"
      "wheel"
      "disk"
      "libvirtd"
      "docker"
      "audio"
      "video"
      "input"
      "systemd-journal"
      "networkmanager"
      "network"
      "davfs2"
      "sudo"
      "adm"
      "lp"
      "storage"
      "users"
      "tty"
      "dialout"
      "uucp"
    ];
    openssh.authorizedKeys.keys = [
      # bernd smartphone key:
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmVutzPV7bDLbyorV+kK4xQ6usfYzxHdT/M76iQ3bgcVHdtAMPN/5hOnvCj5NwEiUn2k7W5WKHrwKYOdYvDHPohMi/y2j0ZXvLrRIOFfKfAmHQWJkjC527N8xUBrM+qBl/oHpjTCGS4Ia7lY7ADZBKvpEHyQ/prdVMa+pmChQHFiALEipoHBjsM8A984hRVI7bzvBkzO0mVo0TAylsr9xxMqjROqtZHNIb2dMPgx4Lbx3uFHKN8yQLT8Yhjx3ViVp4jgcMdSYtvK0i+xXsl6KwDH3g9HM921ZHE+gbA02vOmm0zXQJmiqW+pwuP3iQigxWsK/3FYI45jpaltmsJHg9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ15zqjBbi6HCBJCkTLKgjREBUBXEmZHMDmtMU7nHoNp"

      # ipad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC04QRLXi5YkWo5zuGYd0ppVRSH37f2AB/oE2TDE/Ju8671aLllI8evSAkgiCDflkGKvcYe2gFHdQbgslqODh5pBCXO+AYPqScFHrmDm+oo8cGpEKM/I67gW9d4aHHMQZH0BMOtVK3dG/OG7gGlHprRJLVq2CkWZZ5cr20f239X4Ul1tR/hvA+8Sw37vrqzT7HLBHi/PElQ2NiXaSSBsywVczQtb/brlxjFILIWJ3Ug++eAyyzwUNOWA9PlfuwXLYHMHuLom3pmFUC0Yh2WN9ofGzcFwjjg3MeYsWT+WBSgt7sBAGdQBuAAm5SeKiaUqyVVBNu2+p+TvAENEHra1pKsYFpivWw3FMj7F93UkZWQZFMP7iiUKN3OfJOS4yKofaa/5jj4emzlTRsKHF5JN5uxjnXzaEaN7l7IQeoJFJeYM0PHa9Iwu3AM+0RmHEkNeOKcSou5nuqnsh+fS2aX8afec6q0+/XFPiaLdb93qF6823SXO5lidmjdLzSKRWINyMT4WFKK0ngriqrv9KCbTDjojBdsKkWWTnJLY26b2y9mTLaCePKuIuGRPIbSZR+LImu9H8xU1dXzj1H0wTNpI+Jr21P1RJcUK/pGcyr0+r8TJvdkBzINMk/UYGbnUMm83egA0unOyKR9GYktmzROPxR1bXVesoXaUPfpfw2Y6Y5MuQ=="

      # woodserver
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+qvbVWlZRERjS1MohguRWZgq/r3+K8TRgp981RHtUop/LBjyzc4/bBM3q7dIu+6WatORZuk52Eu+quagYtU2OscYX5+j4djkC6s6/FzIkNITrnSQw3+K+M9wAYINfehu8AkojQ/l/6eIrPkxt4vtCBoVKo2BnV0K45klBCU29IhaJgibZ7L4wsKy4MltYAuQQaooyOJVWLlvseRYKCviZ1lPTD9Yy8Z3zKj5c8w3QK5RngozzgOWtX0+KjUWS4/fJWmp+jl7ijhS2kGqUNTgBGqMNAcZwdoggntDnESeBuaokefedJwcoAJfq38U/lnIvPL4ygRnIAYeFoIcu0fnB bernd@debian-wood-server"

      # eis-remote
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6"

      # bernd ssh
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe"
      # work
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ"
    ];
    initialPassword = "bernd";
    # shell = pkgs.fish;
  };
  users.extraGroups.vboxusers.members = [ "bernd" ];
  users.extraGroups.video.members = [ "bernd" ];
  users.extraGroups.wireshark.members = [ "bernd" ];
}
