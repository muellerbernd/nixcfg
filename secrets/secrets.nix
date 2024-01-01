let
  systems = {
    t480ilmpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIjDqWjAYK7UcAaaJSzuPyYAXzFonpUL1N2rInH0sgY";
    biltower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAt7MEJjzVNUPs5KIkE55lw6+Ss6n9EEspuUQJsZm3J";
  };
  users = {
    bernd = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr7tntTSMnedzhPA9ScXtX5JtRlsqQEqZisSXV/gs9Z7eDOrFiLZFVCZ7M+z9U4TvXCkEw1r06ruLcYHim5wSSLhW7tHpFm7fs1CA9gbftbUkKHx8Po+f6tA9J+f60gQHJeG2KPaYzjeBMIc4e+4E4jj0d+zzGUrKTcNu6fMZUT+dA1TR4+sCH5eTi476avLdbAcgYUWnuUJCXixFjjhdalIClcZGFnNFXz3CZfnPiE5tBitAMZJjc4Nkz14PyTQvDH7OSkqQvlBZ8L56SvZSX9ZxEbClgeVUEVI63QYIVjEgeOB4xFr0dpIlPlwAhaBsakr7hmvHpllvMgerUC61Et6T3PWmNO+uAyv0UBcWQG1lMXLlfnN4NfYMoun69kmM/t0KkhT6w2sHjBpuzaoz/0YZSniTOv/Ov5igK/OOwAcshXV0n9Tf31oPqe1UaI6CtyT1qrWgnvxTkTRlxT80g+Ky99BCCCE5BKvFrlq3UziMrRo3NNJ3q/diBhwcvDbc= bernd@t480i7";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # "secret1.age".publicKeys = [ user1 system1 ];
  # "secret2.age".publicKeys = users ++ systems;
  "distributedBuilderKey.age".publicKeys = allUsers;
}
