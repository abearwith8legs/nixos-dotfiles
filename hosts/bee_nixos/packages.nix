{ config, pkgs, ... }:

{
  # Everything already in modules/system/packages.nix (shared) is
  # installed on this host too. This file only adds what was on the
  # laptop before the merge and isn't already covered there — nothing
  # from the old laptop list was silently dropped, but a few near-
  # duplicates were left out on purpose, noted below.
  environment.systemPackages = with pkgs; [
    rustdesk-flutter
    kitty
    kdePackages.kate
    xfce.thunar
    kiwix
    kiwix-tools
    freeplane
    polyglot
    emulationstation-de

    # Not included here:
    # - `notepadqq` — removed from nixpkgs in 2023 (upstream stopped
    #   maintaining it), which is what broke the first build. Kate
    #   (above) plus geany/vscodium (shared list) already cover the
    #   GUI-text-editor niche it filled.
    # - `flatpak` package + a second `services.flatpak.enable` — the
    #   shared modules/system/services.nix already enables the flatpak
    #   service, which pulls in the CLI on its own.
    # - `floorp` (plain) — the shared packages.nix already installs
    #   `floorp-bin` via a pinned-version overlay. These are two
    #   different derivations of the same browser; decide if you want
    #   both or just one and drop the other.
  ];
}
