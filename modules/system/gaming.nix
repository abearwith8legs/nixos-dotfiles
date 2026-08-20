{ config, pkgs, inputs, ... }:

{
  # Realtime scheduling privileges for audio/gamemode — safe to share
  # across hosts. Hybrid-graphics GPU offload (DRI_PRIME) is machine-
  # specific and lives in the host's own configuration.nix instead.
  security.rtkit.enable = true;
}
