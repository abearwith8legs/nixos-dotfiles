{ config, pkgs, lib, ... }:

{
  # Fingerprint reader — laptop-only hardware. Don't import this on
  # beenixos: forcing fprintAuth without a reader present would break
  # login/sudo there instead of just falling back gracefully.
  services.fprintd.enable = true;

  security.pam.services.login.fprintAuth = lib.mkForce true;
  security.pam.services.sudo.fprintAuth = lib.mkForce true;
}
