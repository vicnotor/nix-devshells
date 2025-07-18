{
  description = "Simple R devshell flake";

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
    overlays.default = final: prev: rec {
      rEnv = final.rWrapper.override {
        packages = with final.rPackages; [
          rmarkdown
          tidyverse
          ggplot2
          ggpubr
          languageserver

          # Required for grind.R by Rob de Boer
          coda
          deSolve
          rootSolve
          FME
        ];
      };
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = [pkgs.rEnv];
      };
    });
  };
}
