{
  description = "Simple devshell flake template";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        # The Nix packages provided in the environment
        # Add any you need here
        packages = with pkgs; [];

        # Set any environment variables for your dev shell
        env = {};

        # Add any shell logic you want executed any time the environment is activated
        shellHook = ''
        '';
      };
    });
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.stdenv.mkDerivation {
        pname = "default_pname";
        version = "0.0.1";
        src = ./.;
      };
    });
  };
}
