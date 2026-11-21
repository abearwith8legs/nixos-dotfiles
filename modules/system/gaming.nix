{ config, pkgs, inputs, ... }:

{
  security.rtkit.enable = true;

  # Ensure gamescope and mangohud are available in systemPackages
  environment.systemPackages = with pkgs; [
    gamescope
    mangohud
  ];

  programs.rsi-launcher = {
    enable = true;

    # Wrap the launcher inside Gamescope and MangoHud automatically
    preCommands = ''
      export DXVK_HUD=0
      export MANGOHUD=1
    '';
  };
}
