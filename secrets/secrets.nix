let
  systems = {
    # keep-sorted start
    t480ilmpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIjDqWjAYK7UcAaaJSzuPyYAXzFonpUL1N2rInH0sgY";
    t480ammera = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFQbamL2LmSxUVxDrFwGIAKOYBSECcMCip5Jj/h6AmEC";
    mue-p14s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF75o0sys99U1zvVFWVMsEssGERvqhQ4xLelHTaIyZ9F";
    x240 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMmJAk/pUHoHWYqk/RTBFT1P0BvJodvdR/RoA+SCAbZl";
    biltower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAt7MEJjzVNUPs5KIkE55lw6+Ss6n9EEspuUQJsZm3J";
    nixetcup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ26gpu5goRDBoFe/2+yKxP4MlUVkbB46CVh719pfrs3";
    fw13 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFkZszXXIt+xvGwWi6yp+m6yga92eBf7JXUHwFNOQJwx";
    rover = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAx9ti665hiwHgTelMMrpE5zVrvVxNgVS/xJCyQ869hc";
    pi4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLoMwcSBDrjLx4c1XG29H9ACFhEf5cq3N5J6GUMkBjb";
    # keep-sorted end
  };
  users = {
    # keep-sorted start
    bernd = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe";
    mue-p14s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ";
    # keep-sorted end
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  "distributedBuilderKey.age".publicKeys = allUsers ++ allSystems;
  "eisVpnP14sConfig.age".publicKeys = allUsers ++ allSystems;
  "eisVpnConfig.age".publicKeys = allUsers ++ allSystems;
  "workSmbCredentials.age".publicKeys = allUsers ++ allSystems;
  "matrix-registration.age".publicKeys = allUsers ++ allSystems;
  "matterbridge.age".publicKeys = allUsers ++ allSystems;
  "wgServerPrivKey.age".publicKeys = allUsers ++ allSystems;
  "berndMail.age".publicKeys = allUsers ++ allSystems;
}
