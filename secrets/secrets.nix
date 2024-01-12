let
  systems = {
    t480ilmpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAIjDqWjAYK7UcAaaJSzuPyYAXzFonpUL1N2rInH0sgY";
    t480ammera = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvr23QzFcxZeZeaa3UhnjojhfzKdayQad3YOecygzMs";
    mue-p14s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF75o0sys99U1zvVFWVMsEssGERvqhQ4xLelHTaIyZ9F";
  };
  users = {
    bernd = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgmYk5cp157HAe1ZKSxcW5/dUgiKTpGi7Jwe0EQqqUe";
    mue-p14s = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRd4LEWh7KvCNHXPJm39YcCAqwwdqJsGr9ARS6UJkJQ";
  };
  allUsers = builtins.attrValues users;
  allSystems = builtins.attrValues systems;
in
{
  # "secret1.age".publicKeys = [ user1 system1 ];
  # "secret2.age".publicKeys = users ++ systems;
  "distributedBuilderKey.age".publicKeys = allUsers ++ [ systems.t480ilmpad systems.mue-p14s systems.t480ammera ];
}
