{
  description = "My devshell templates";

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
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.stdenv.mkDerivation {
        name = "mydev";
        src = ./.;

        installPhase = ''
          echo "OUT = $out"
          cp -r $src/languages $out

          mkdir -p $out/bin
          cp $src/mydev.sh ./mydev.tmp
          substituteInPlace ./mydev.tmp \
            --replace "@langdir@" "$out/languages"
          install -m755 ./mydev.tmp $out/bin/mydev
        '';
      };
    });
  };
}
