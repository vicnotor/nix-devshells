{
  description = "Simple .NET devshell flake";

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
            dotnetCorePackages.sdk_9_0-bin
          ];
        };
    });
    packages = forEachSupportedSystem ({pkgs}: {
      default = pkgs.buildDotnetModule {
        pname = "default_pname";
        version = "0.0.1";
        src = ./.;

        # Specify the following if needed
        # projectFile = "src/project.sln";
        # nugetDeps = ./deps.json; # see "Generating and updating NuGet dependencies" section for details
        # dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
        # dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;
        # executables = [ "foo" ]; # This wraps "$out/lib/$pname/foo" to `$out/bin/foo`.
        # packNupkg = true; # This packs the project as "foo-0.1.nupkg" at `$out/share`.
        # runtimeDeps = [ ffmpeg ]; # This will wrap ffmpeg's library path into `LD_LIBRARY_PATH`.
      };
    });
  };
}
