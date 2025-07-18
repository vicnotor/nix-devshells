{
  description = "Simple OCaml devshell flake";

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
      dbw = pkgs.writeShellScriptBin "dbw" ''
        dune build --watch
        dune clean
      '';
    in {
      default = pkgs.mkShell {
        packages = with pkgs;
          [
            ocaml
            dbw
          ]
          ++ (with pkgs.ocamlPackages; [
            ocaml-lsp
            ocamlformat
            dune_3
            findlib
          ]);
      };
    });
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.buildDunePackage {
        pname = "default_pname";
        version = "0.0.1";

        src = ./.;
      };
    });
  };
}
