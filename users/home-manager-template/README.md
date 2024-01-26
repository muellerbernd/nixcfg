# NixOS setup via home-manager

The main system config is managed by a root user.
Please use for your user configurations [home-manager](https://nix-community.github.io/home-manager/).
This README describes how to use home-manager.

# Copy home-manager config template

First of all you need to copy the provided template into `~/.config/home-manager`.

```bash
cd ~/.config/home-manager-template ~/.config/home-manager
```

# Bootstrap home-manager via flake if not on preconfigured NixOS

Copy local [`./flake.nix`](./flake.nix) and [`./home.nix`](./home.nix) into `~/.config/home-manager`.
You will need an Nix installation with flake support.

```bash
cd ~/.config/home-manager
# bootstrap home-manager, this will install home-manager
nix run . -- build --flake .
```

# Using home-manager

Edit [`./home.nix`](./home.nix) in `~/.config/home-manager/` by adding new software or by configuring your dotfiles via home-manager.
Take a look at the [official documentation](https://nix-community.github.io/home-manager/) on how to use home-manager.

```bash
# rebuild home-manager config
home-manager build
# rebuild and activate home-manager config
home-manager switch
```
