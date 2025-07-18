{
  description = "Simple C devshell flake";

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
            gcc
            clang
            clang-tools
          ];
          shellHook = ''
            echo "Generating .clangd with correct include paths..."

            INCLUDE_PATHS=$(clang -E -x c - -v < /dev/null 2>&1 \
              | sed -n '/#include <...> search starts here:/,/End of search list./p' \
              | grep -v '^#' \
              | grep -v 'End of search list.' \
              | sed 's/^ \{1,\}//' \
              | sed 's/.*/"-isystem", "&"/' \
              | paste -sd, -)

            cat > .clangd <<EOF
            CompileFlags:
              Add: [''${INCLUDE_PATHS}]
            EOF

            echo ".clangd generated:"
            cat .clangd
          '';
        };
    });
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.stdenv.mkDerivation {
        pname = "default_pname";
        version = "0.0.1";
        src = ./.;

        # Either specify buildPhase and installPhase here or use a Makefile
        # with build and install instructions.
        # E.g.,
        # buildPhase = ''
        #   make
        # '';
        # installPhase = ''
        #   mkdir -p $out/bin
        #   cp default_pname $out/bin/
        # '';
      };
    });
  };
}
