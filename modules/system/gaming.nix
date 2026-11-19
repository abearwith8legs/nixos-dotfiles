{ config, pkgs, inputs, ... }:

{
  # Realtime scheduling privileges for audio/gamemode — safe to share
  # across hosts. Hybrid-graphics GPU offload (DRI_PRIME) is machine-
  # specific and lives in the host's own configuration.nix instead.
  security.rtkit.enable = true;

  # Star Citizen launcher & system tuning via nix-citizen module
  programs.rsi-launcher = {
    enable = true;
    # setLimits = true; # Default: sets vm.max_map_count to 16777216 and file limits
  };
}