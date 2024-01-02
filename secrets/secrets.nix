let
  systems = {
    t480ilmpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIjDqWjAYK7UcAaaJSzuPyYAXzFonpUL1N2rInH0sgY";
    mue-p14s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF75o0sys99U1zvVFWVMsEssGERvqhQ4xLelHTaIyZ9F";
  };
  users = {
    bernd = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr7tntTSMnedzhPA9ScXtX5JtRlsqQEqZisSXV/gs9Z7eDOrFiLZFVCZ7M+z9U4TvXCkEw1r06ruLcYHim5wSSLhW7tHpFm7fs1CA9gbftbUkKHx8Po+f6tA9J+f60gQHJeG2KPaYzjeBMIc4e+4E4jj0d+zzGUrKTcNu6fMZUT+dA1TR4+sCH5eTi476avLdbAcgYUWnuUJCXixFjjhdalIClcZGFnNFXz3CZfnPiE5tBitAMZJjc4Nkz14PyTQvDH7OSkqQvlBZ8L56SvZSX9ZxEbClgeVUEVI63QYIVjEgeOB4xFr0dpIlPlwAhaBsakr7hmvHpllvMgerUC61Et6T3PWmNO+uAyv0UBcWQG1lMXLlfnN4NfYMoun69kmM/t0KkhT6w2sHjBpuzaoz/0YZSniTOv/Ov5igK/OOwAcshXV0n9Tf31oPqe1UaI6CtyT1qrWgnvxTkTRlxT80g+Ky99BCCCE5BKvFrlq3UziMrRo3NNJ3q/diBhwcvDbc= bernd@t480i7";
    mue-p14s = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKZ62DjNQHx4q9VLpjMAby191PoKMdP2x+qZmmdCQgk/4s7/OhDTzYCzUZE5D6VgAN3Gg2uWnqQ5QezbevwOKf4ZGDQ/yJDFgGeYHmPLDvvdnb2KjPWznR+GQ8aqdCe4fCmR4uyViwrGCPY3vvGYJpubdmDH/xJS1orev6JeLovR65sq+OSTaTXE3tlHGOZKGJkAPrXc9rAATwUusNPDWuKXpGA4gaXqMFXdPYv11lJDcd7b7ApwSg8TuQmH99U+tiJLObjwVjW92QweyL3wemG0Ch5LF2ffAJXjyWDz9Atp/yle6NBRqwclFIVJQX5mHNwgL8HSrTsxr8t0FaPqqZ+tbirwfSqnaBnoLLoeHjtst2hQmodGrUaN2c7knnVHO5CxM04uiF4MMOwe3qrVf4TtN4bLtJqPW+73HtnYkMSUasRzwnpa/MWYIuU6fabZX3uXTIJxJIJ2POTsmXVj8oIEx4vQKOXlAAK/rWcu26ZwjtUXms2dV9v57xDcu8pG8= bernd@ros-p14s-linux";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # "secret1.age".publicKeys = [ user1 system1 ];
  # "secret2.age".publicKeys = users ++ systems;
  "distributedBuilderKey.age".publicKeys = allUsers ++ [ systems.t480ilmpad systems.mue-p14s ];
}
