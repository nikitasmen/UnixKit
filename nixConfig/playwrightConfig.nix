{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.playwright-driver  # provides the Playwright driver with browsers
    pkgs.nodejs
    pkgs.glib
    pkgs.nss
    pkgs.nspr
    pkgs.dbus
    pkgs.atk
    pkgs.atkmm
    pkgs.expat
    pkgs.at-spi2-core
    pkgs.libp11
    pkgs.systemd # for libudev.so.1
    pkgs.alsa-lib
    pkgs.gtk3
    pkgs.cairo
    pkgs.pango
    pkgs.fontconfig
    pkgs.freetype
  ];

  shellHook = ''
    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    echo "✅ nix-shell loaded with Playwright and NixOS-compatible browsers"
  '';
}