{
  description = "Simple QML devshell flake";

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
      default =
        pkgs.mkShell
        {
          packages = with pkgs; [
            kdePackages.qtdeclarative
          ];
          shellHook = ''
            echo "Generating empty .qmlls.ini file if non-existent"
            touch .qmlls.ini
          '';
        };
    });
  };
}
