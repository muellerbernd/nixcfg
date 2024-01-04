{ config, pkgs, ... }: {
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
    ];
    openssh.authorizedKeys.keys = [
      # bernd smartphone key:
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmVutzPV7bDLbyorV+kK4xQ6usfYzxHdT/M76iQ3bgcVHdtAMPN/5hOnvCj5NwEiUn2k7W5WKHrwKYOdYvDHPohMi/y2j0ZXvLrRIOFfKfAmHQWJkjC527N8xUBrM+qBl/oHpjTCGS4Ia7lY7ADZBKvpEHyQ/prdVMa+pmChQHFiALEipoHBjsM8A984hRVI7bzvBkzO0mVo0TAylsr9xxMqjROqtZHNIb2dMPgx4Lbx3uFHKN8yQLT8Yhjx3ViVp4jgcMdSYtvK0i+xXsl6KwDH3g9HM921ZHE+gbA02vOmm0zXQJmiqW+pwuP3iQigxWsK/3FYI45jpaltmsJHg9"

      #bernd lenovo x240 key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/XkOH/IXFjWKWj3RUXP44MHH9P551VeA37MXhl/FeTcitQEomTQzOld6sMzbfca0I0IID25HsXEVEwohp6cHB1sU/YecTu70Ya29r1uqnCmZsnipiNYIAvf8B7GYZZrsWMRn582Cj0vL0zWr5x4SaTydPEifurzUM8DUQLMuN3i1o8yBaUCnqQbjyTec07EpRl15qysWLRW/fg4+fw+V4u91E8X+fUCH63H4pAGRKuXybMlA9q5IDuvTAdlcXi3CiTVp7WKWo0rwkTgzNvvLG7gSyoZu0VCoXW0yTaGjCPg7k7vUsSpUutiIKo8TG1rtEOBS/efzVWc0j1bbBWl2Tgu6JfjYwGfHt//URPvoy4TMJLjoxQ1t3HoiBGhVvSpDeqSD1N2WeutSmArfdlHa0D3hy5lF/uOlEaUhxxxlOOy4F6EPo25JpAiny+UxMuABiH/YmqfuGfJ+TMbZyO9N7ePJuCH/GafLxNjb64yS9ogTGipanb3lQfi+X2zp7ZUU= bernd@x240"

      # bernd lenovo t480 key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1kobWixjrXRDr4017qV0PxX9+29Sw94o54B+BV6gcBug6q6UnE5cVXB6Se3Yw5dBV0Cw0zGJ6IBCEp2jT4HrVzhLb5Qw59pgaXj7YFkqnRv2Srnp0QHp3GewbKveM9mTxn8NVjlE/d3jMjOlKDW32eRo1hhL3d3RWxIRYSzd9GNaU9029bPWmsUTwsGqF4qr0jASD6ktJENgLwSI+Gk8AbjZnqRNXZzIN+lfQ4Hg4GusuvtCfDAMhILNpATuWoTo7P2K+8TBRQ4uJ+vzjsXWw+zf7BvQSrpv6r54Zku5YZMqnsdXNdpsDfhWoABXKiiHBXd10stFBqhh24PlUpEq+kOe8DeC5o/xRK5xMnGj59ciEQip7Se/Lcfa+nj1zbXImaSn9Xp9jt8RnlovIve6ExRmc1LzPo248mEANzyWkesGW7dMuYZkCAVep/JZuc33TBd27dd6kkQq73EDRC6TSccpsaIinU+zTyF/0Itz2LllC9tNeqo+d1GnK4Sf85xk= bernd@home-t480"

      # t480i7
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr7tntTSMnedzhPA9ScXtX5JtRlsqQEqZisSXV/gs9Z7eDOrFiLZFVCZ7M+z9U4TvXCkEw1r06ruLcYHim5wSSLhW7tHpFm7fs1CA9gbftbUkKHx8Po+f6tA9J+f60gQHJeG2KPaYzjeBMIc4e+4E4jj0d+zzGUrKTcNu6fMZUT+dA1TR4+sCH5eTi476avLdbAcgYUWnuUJCXixFjjhdalIClcZGFnNFXz3CZfnPiE5tBitAMZJjc4Nkz14PyTQvDH7OSkqQvlBZ8L56SvZSX9ZxEbClgeVUEVI63QYIVjEgeOB4xFr0dpIlPlwAhaBsakr7hmvHpllvMgerUC61Et6T3PWmNO+uAyv0UBcWQG1lMXLlfnN4NfYMoun69kmM/t0KkhT6w2sHjBpuzaoz/0YZSniTOv/Ov5igK/OOwAcshXV0n9Tf31oPqe1UaI6CtyT1qrWgnvxTkTRlxT80g+Ky99BCCCE5BKvFrlq3UziMrRo3NNJ3q/diBhwcvDbc= bernd@t480i7"

      # home pi
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChkv3cwb6uP42VaQnLyFDqudjLKi5GsBxp7ewbyLYsrBVcpK/iQIWgOEzh7XD/bWlj8qowaH0NghcFCXqjbzTRB+SYNptAeZHgcWqGtcii3b+7vc78wxHEvNf02TPgb3N2riHMqoL1178b1qrCZwCwgtBprKc2ybDY7mw1Utcbo3jfsj8Yu/3j8adXST9Pt/qILTYN47GCiEjmxN3POF5+WhWcvtr25IbXVc3uv1jJMbcyZZmdBEZB9u3vzTNoB19N3ddauPPkHeSovyLypxBXlGFg5oJVuZGQV6W0E/PjyhX7K4zN0/+2ekRaJ49Pi8Btfjf1y3puOvcV0FeB4xTf"

      # ipad
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC04QRLXi5YkWo5zuGYd0ppVRSH37f2AB/oE2TDE/Ju8671aLllI8evSAkgiCDflkGKvcYe2gFHdQbgslqODh5pBCXO+AYPqScFHrmDm+oo8cGpEKM/I67gW9d4aHHMQZH0BMOtVK3dG/OG7gGlHprRJLVq2CkWZZ5cr20f239X4Ul1tR/hvA+8Sw37vrqzT7HLBHi/PElQ2NiXaSSBsywVczQtb/brlxjFILIWJ3Ug++eAyyzwUNOWA9PlfuwXLYHMHuLom3pmFUC0Yh2WN9ofGzcFwjjg3MeYsWT+WBSgt7sBAGdQBuAAm5SeKiaUqyVVBNu2+p+TvAENEHra1pKsYFpivWw3FMj7F93UkZWQZFMP7iiUKN3OfJOS4yKofaa/5jj4emzlTRsKHF5JN5uxjnXzaEaN7l7IQeoJFJeYM0PHa9Iwu3AM+0RmHEkNeOKcSou5nuqnsh+fS2aX8afec6q0+/XFPiaLdb93qF6823SXO5lidmjdLzSKRWINyMT4WFKK0ngriqrv9KCbTDjojBdsKkWWTnJLY26b2y9mTLaCePKuIuGRPIbSZR+LImu9H8xU1dXzj1H0wTNpI+Jr21P1RJcUK/pGcyr0+r8TJvdkBzINMk/UYGbnUMm83egA0unOyKR9GYktmzROPxR1bXVesoXaUPfpfw2Y6Y5MuQ=="

      # ilmpc
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDqKRHvI307BoGuoFFC/cMwL1BkUKBNLWJvxpUsYhUA5yAEF2HCxYXmRB6rSAZfx5foXcuaemJf+HD4T3vehNTN8Kjq/eqAcN1LBVs5dWJ+X62wt/4hEhvYqHKNlXQk6ZRRlubXmxE/YPEpeP2QbX/fOduXI7GlNkdCDMXOrSfcj50ZwnldZib/q28QkIJ8PC3hI2apxSW6EstVVUlcgVmmw4rUbQSk+6PuwN9sPcYHFH6P24Yml04pjsQKZlNwm95AJHDPfN5Fp7MFk4ISBesTBtnuNqfjb4z6KwztE9rSQycwaSAwk/CGSszW4mRbusNcakVeVkyW5hMkiGdWIgnfvFa95zwBggfra2AFxuJUHjZsVP5JnJ5V3IpvTticoulbsdCnN1an7cy2il2VFibmDdMAwvds5eo1mrEsRohVfu/bmpxq3neqTj5T5j2ycG4Z063PqQecj8JW5tpM+weM5V7ldf4+yuwBnFwHkgIwD1862zNWRH7cII+6dKjRDoM= bernd@ilmpc"

      # biltower
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQmne9u2qYFYgQGXZPowIwQrXX0cn5vS9YTTdCNxvgCD819IzNQVyiE7gJePddT3V62CIM5ksZhZx2B88SoFw6PXJ+76dAtaQCeFOXqA8eoJ5eKUkXawIuCYTnl9D2GC51fmmPJH4PS0d0tcg1OoROuipat+rli6IZqop5UKgsaHgVeOgERJ4O6grt6IeAi4W8vORrY5WpG+UXZtK5PGNBQV5B6S/8nlRPEoXe8aNF0/mVoVOiCGn5u1QJD3Ibv/eHO/e07wO0LBRPsUyfsN5yEyfUlvVC3eHSBRb25ISmecJKBosORIpN/jcl8NG9hAQt9030wfYart5eOjsfCSp8gIzgKuHM31LIzySr5mkodwFgfnFFU93NkA507KbIVqs8dwp1QRdeFMhsrj+LKLOq7GGWODDit8x7dxt+5rjXvlc7X47DkTJCJch2tKOLtaw7qvZvsYLgyxpXRQ7mNoHn5QhtFCVq334HuYWa0sl0EfY1BkpkQDVo8jU3uNvdn4E= bernd@biltower"

      # t540p
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdcW1uQt56v5wwANefzUXNlBh/5h4lcj4dfG0Z3Ps3aUtLtFFZJHVhOnEkVfViqMDoSlznzGvndAMV2U2IPlp4yxx29sZ1gCQCiM4SEtwW5VjpHBLvpEYR8Nha+GwFU4psyZ3CKvhz9clMI+Obnt2GsVzWYRVzHhiRrda974/W/Hv9U3OUbJZy/rJ02UQ8bid2t8SRtXsDOC31pOSd/QGu+WgCnBZ6yaP7I539tfAop+Cy3eNuoSKsmcDIei3qsaq98k2RTrJX66Fqqsi4aTCGCd6p2CAFJhCtXPq4L9njjrW8X4iGoWWulkvgO9j2V0KEZOPGlKlFly50Evu040Wq/Fhlq7IhSTb5C379kqjNQBAWw6Ltq06y9gyOUORfBM16bkDMHjpaO8A0enGzM5Wr8beKWC/w4gpPIBNwrTE2EoQ8JjpxUuBai4Bz6S1eK27AA+61PWiOWoxoGUMZeFM6OZsgRfeKps+YayGeqxjGpgqMkAY78A3QcQGQy49Gnls= bernd@ros-t540p-linux"

      # p14s work
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKZ62DjNQHx4q9VLpjMAby191PoKMdP2x+qZmmdCQgk/4s7/OhDTzYCzUZE5D6VgAN3Gg2uWnqQ5QezbevwOKf4ZGDQ/yJDFgGeYHmPLDvvdnb2KjPWznR+GQ8aqdCe4fCmR4uyViwrGCPY3vvGYJpubdmDH/xJS1orev6JeLovR65sq+OSTaTXE3tlHGOZKGJkAPrXc9rAATwUusNPDWuKXpGA4gaXqMFXdPYv11lJDcd7b7ApwSg8TuQmH99U+tiJLObjwVjW92QweyL3wemG0Ch5LF2ffAJXjyWDz9Atp/yle6NBRqwclFIVJQX5mHNwgL8HSrTsxr8t0FaPqqZ+tbirwfSqnaBnoLLoeHjtst2hQmodGrUaN2c7knnVHO5CxM04uiF4MMOwe3qrVf4TtN4bLtJqPW+73HtnYkMSUasRzwnpa/MWYIuU6fabZX3uXTIJxJIJ2POTsmXVj8oIEx4vQKOXlAAK/rWcu26ZwjtUXms2dV9v57xDcu8pG8= bernd@ros-p14s-linux"

      # woodserver
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+qvbVWlZRERjS1MohguRWZgq/r3+K8TRgp981RHtUop/LBjyzc4/bBM3q7dIu+6WatORZuk52Eu+quagYtU2OscYX5+j4djkC6s6/FzIkNITrnSQw3+K+M9wAYINfehu8AkojQ/l/6eIrPkxt4vtCBoVKo2BnV0K45klBCU29IhaJgibZ7L4wsKy4MltYAuQQaooyOJVWLlvseRYKCviZ1lPTD9Yy8Z3zKj5c8w3QK5RngozzgOWtX0+KjUWS4/fJWmp+jl7ijhS2kGqUNTgBGqMNAcZwdoggntDnESeBuaokefedJwcoAJfq38U/lnIvPL4ygRnIAYeFoIcu0fnB bernd@debian-wood-server"

      # eis-remote
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJij7unHFBR6aCD75wKYdcjVikDaxOhF6laTR1gdzTE6 bernd@t480ilmpad"
    ];
  };
  users.extraGroups.vboxusers.members = [ "bernd" ];
  users.extraGroups.video.members = [ "bernd" ];
  users.extraGroups.wireshark.members = [ "bernd" ];
}
