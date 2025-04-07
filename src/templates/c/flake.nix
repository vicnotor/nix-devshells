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
    devShells = forEachSupportedSystem ({pkgs}: {
      default =
        pkgs.mkShell
        {
          packages = with pkgs; [
            gcc
            clang
            clang-tools # Could be removed because clangd is installed in nvim through mason.nvim
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
  };
}
