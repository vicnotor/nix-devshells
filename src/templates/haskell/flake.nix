{
  description = "Simple Haskell devshell flake for imperative use of cabal";

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
    devShells = forEachSupportedSystem ({pkgs}: let
      cabalclean = pkgs.writeShellScriptBin "cabalclean" ''
          rm -r dist-newstyle
      '';
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          (pkgs.haskellPackages.ghcWithPackages
            (ps:
              with ps; [
                cabal-install
                haskell-language-server
                hlint
              ]))
            cabalclean
        ];
      };
    });
  };
}
