{
  description = "shade - HyprDots Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          shadevm = import ./Scripts/shadevm { inherit pkgs; };
        in
        {
          default = {
            type = "app";
            program = "${shadevm.defaultPackage}/bin/shadevm";
          };
          shadevm = {
            type = "app";
            program = "${shadevm.defaultPackage}/bin/shadevm";
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          shadevm = import ./Scripts/shadevm { inherit pkgs; };
        in
        {
          default = shadevm.defaultPackage;
          shadevm = shadevm.defaultPackage;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              qemu
              curl
              python3
              git
              coreutils
              findutils
              gnused
              gawk
            ];
          };
        }
      );
    };
}
