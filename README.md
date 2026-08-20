# nixos config

Flake-based NixOS + home-manager config, two hosts: `beenixos` (desktop,
Plasma) and `bee_nixos` (laptop, GNOME).

## Layout

```
flake.nix              inputs + nixosConfigurations, one entry per host
hosts/<name>/
  hardware-configuration.nix   machine-specific, never shared between hosts
  configuration.nix            imports shared modules/system/*, sets
                                host-specific overrides (hostName,
                                stateVersion, power, swap, etc.)
  desktop.nix                  which DE this host runs (Plasma vs GNOME)
  <other host-only files>      e.g. beenixos/filesystems.nix (extra
                                drives), bee_nixos/graphics.nix (NVIDIA
                                prime), bee_nixos/security.nix (fprintd),
                                bee_nixos/storage.nix, bee_nixos/packages.nix
modules/system/*.nix   shared system config, safe to import on any host
modules/home/           home-manager config for user `rowan`, shared
                         (note: ship-theme is Plasma-only, see its header)
tools/                  standalone scripts (recolor-kvantum.py)
```

The rule of thumb: if a setting is true of the *user* (shell aliases,
theme, dotfiles), it goes in `modules/home/`. If it's true of *every
machine* (audio stack, printing, package list), it goes in
`modules/system/`. If it's true of *one specific machine* (hostname,
disk UUIDs, GPU bus IDs, swap size, power governor, `stateVersion`,
which DE it runs), it goes in that host's `hosts/<name>/` files.

`system.stateVersion` in particular must stay pinned to whatever
release each machine was originally installed with (`26.05` for
beenixos, `24.05` for bee_nixos) — never bump it to match another
host or the current channel.

## Known issues carried over from the laptop's old config

- `hosts/bee_nixos/storage.nix` has a udev rule targeting a disk UUID
  that doesn't match the current `/mnt/storage` UUID — likely stale
  from before that drive was reformatted. Run `lsblk -f` on the laptop
  and fix whichever side is wrong.
- `hosts/bee_nixos/graphics.nix`'s eGPU specialisation sets
  `KWIN_DRM_DEVICES`, which is a Plasma/KWin-specific env var and does
  nothing under GNOME's Mutter compositor. Harmless no-op for now;
  worth removing or replacing if the eGPU specialisation is actually
  used.
- `hosts/bee_nixos/packages.nix` still installs plain `floorp` while
  the shared package list installs a pinned `floorp-bin` — two
  different derivations of the same browser. Pick one.

## Adding a new host

1. Install NixOS on the machine normally.
2. On that machine, generate its real hardware config:
   ```
   sudo nixos-generate-config --show-hardware-config > hosts/<name>/hardware-configuration.nix
   ```
3. Write `hosts/<name>/configuration.nix`, importing the shared
   `modules/system/*.nix` that apply plus whatever's host-specific
   (hostName, stateVersion, desktop.nix, power, swap).
4. Add `<name> = mkHost "<name>";` to `flake.nix`.
5. Make sure `<name>` matches the machine's actual `networking.hostName`
   — the `rebuild`/`full-rebuild` fish aliases build the flake target
   from `(hostname)`, so the two need to agree.
6. Build and switch:
   ```
   sudo nixos-rebuild switch --flake .#<name>
   ```

## Syncing between machines with git

This repo has no remote configured yet — it's local-only. To move it
to another machine:

1. Push it somewhere both machines can reach — a private GitHub/GitLab
   repo is easiest:
   ```
   git remote add origin git@github.com:<you>/nixos-config.git
   git push -u origin master
   ```
   (No GitHub? `git bundle create nixos.bundle --all` and copy the
   bundle over by USB/scp, or clone directly host-to-host over SSH:
   `git clone rowan@bee_pc:/etc/nixos`.)
2. On the other machine:
   ```
   sudo git clone <url> /etc/nixos
   cd /etc/nixos
   sudo nixos-rebuild switch --flake .#bee_nixos   # or whichever host
   ```
3. From then on, `rebuild` / `full-rebuild` on either machine commit
   locally and rebuild against their own `hostname` — pull/push
   between them as normal git remotes when you want to sync changes.

**Don't** clone one host's checkout onto another machine and rebuild
against the *other* host's flake attr — each host's
`hardware-configuration.nix` and extra-mount files point at that exact
machine's disks by UUID. Always build a real machine against its own
host entry.
