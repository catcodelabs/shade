{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:

let
  # Import the unified shell script
  shadevmScript = pkgs.writeShellApplication {
    name = "shadevm";
    runtimeInputs = with pkgs; [
      qemu
      curl
      python3
      git
      coreutils
      findutils
      gnused
      gawk
    ];
    text = builtins.readFile ./shadevm.sh;
  };
in
{
  defaultPackage = shadevmScript;

  mkshadeVM =
    {
      memory ? "4G",
      cpus ? 2,
      extraArgs ? "",
    }:
    pkgs.writeShellApplication {
      name = "run-shadevm";
      runtimeInputs = [ shadevmScript ];
      text = ''
        VM_MEMORY="${memory}" VM_CPUS="${toString cpus}" VM_EXTRA_ARGS="${extraArgs}" shadevm "$@"
      '';
    };
}
