# My Nix devshell templates

## Requirements

- A system with Nix installed (with flakes enabled, obviously)
- (optional) direnv installed

## Installation

Add this project's flake to your NixOS or home-manager flake inputs:

```nix
...

inputs = {
  ... 

  my-devshells = {
    url = "github:vicnotor/my-devshells";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  ...
};

...
```

And then add it either `environment.systemPackages` or `home.packages` as

```nix
inputs.my-devshells.packages.${pkgs.system}.default
```

Then rebuild your NixOS or home-manager system.

## Usage

```bash
mydev $template
```

where `$template` is one of the directory names inside
[src/templates](https://github.com/vicnotor/my-devshells/tree/main/src/templates).

This will copy the `flake.nix`, `flake.lock`, and `.envrc` files from that
directory to your current directory. You can then run

```bash
direnv allow
```

to activate the development environment.

______________________________________________________________________

Heavily inspired by and copied from
[the-nix-way/dev-templates](https://github.com/the-nix-way/dev-templates)
