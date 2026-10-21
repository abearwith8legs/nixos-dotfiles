{ config, pkgs, ... }:

{
  fonts = {
    # Kills the X11 default bundle so Unifont never returns
    enableDefaultPackages = false;

    packages = with pkgs; [
      # --- Core OS Fallbacks ---
      dejavu_fonts
      liberation_ttf
      freefont_ttf

      # --- Clean UI Fonts ---
      inter
      roboto
      noto-fonts

      # --- Terminal & Code ---
      jetbrains-mono
      fira-code

      # --- Linguistics & Complex Scripts ---
      andika
      noto-fonts-cjk-sans

      # --- Font Creation & Inspection Tools ---
      fontforge-gtk
      python3Packages.fonttools
      python3Packages.fontforge
      harfbuzz
    ];
  };
}
