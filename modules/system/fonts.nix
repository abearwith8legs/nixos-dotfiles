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

      # --- Clean UI & Emoji Fonts ---
      inter
      roboto
      noto-fonts
      noto-fonts-color-emoji  # <--- Required for system emoji fallback

      # --- Terminal & Code ---
      jetbrains-mono
      fira-code

      # --- Linguistics & Complex Scripts ---
      andika
      noto-fonts-cjk-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Inter" "Noto Sans" "DejaVu Sans" ];
        monospace = [ "JetBrains Mono" "Fira Code" ];
        emoji     = [ "Noto Color Emoji" ]; # <--- Directs missing glyphs to color emoji
      };
    };
  };
}