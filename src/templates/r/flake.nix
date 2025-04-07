{
  description = "Simple clang devshell flake";

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
          languageserver
          knitr
          rmarkdown
          coda
          deSolve
          dplyr
          plot3D
          rootSolve
          FME
          tidyverse
          ggplot2
        ];
      };
    };

    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          rEnv
          pandoc
          texlive.combined.scheme-full
        ];
      };
    });
  };
}
