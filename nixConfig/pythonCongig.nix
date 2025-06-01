# shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.python3Packages.pip  # Optional: pip
    pkgs.python3Packages.virtualenv  # Optional
  ];
}
