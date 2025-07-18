{
  description = "Simple Zig devshell flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.zig.url = "github:mitchellh/zig-overlay";
  inputs.zls.url = "github:zigtools/zls";

  outputs = {
    self,
    nixpkgs,
    zig,
    zls,
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
        packages = [
          zig.packages.${pkgs.system}.default
          zls.packages.${pkgs.system}.default
        ];
      };
    });
  };
}
