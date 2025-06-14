{ config, pkgs, ... }:

let
  unixKitScripts = pkgs.runCommandLocal "unixkit" {} ''
    mkdir -p $out/bin
    cp -r ${./scripts}/* $out/bin/
    chmod -R +x $out/bin
  '';
in {
  environment.systemPackages = [
    unixKitScripts
  ];
}
