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
        pname = "mydev";
        version = "0.1";
        src = ./.;

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin

          cp -r $src/languages $out

          cp $src/mydev.sh ./mydev.tmp
          substituteInPlace ./mydev.tmp \
            --replace-quiet "@langdir@" "$out/languages"
          install -m755 ./mydev.tmp $out/bin/mydev
        '';
      };
    });
  };
}
