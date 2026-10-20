# verdure: Fedora CoreOS config

Butane/Ignition + Podman Quadlet config for migrating `verdure` from NixOS
to Fedora CoreOS. See the full migration plan this was drafted from:
`C:\Users\Radiance\.claude\plans\for-verdure-raspberry-pi-nested-twilight.md`.

This directory is **not** wired into the flake — it's a standalone config
tree for a different OS, built and applied independently with `butane`/
`coreos-installer`. It's also not self-contained: it reuses the repo's
existing `../secrets/*.age` files directly (see "Secrets" below), so it
must be compiled from the **repo root**, not from inside `coreos/`.

## Layout

```
butane/verdure.bu          Butane source -> compiles to Ignition JSON
quadlet/*.container        Podman Quadlet units (Home Assistant, 2FAuth,
                            Vaultwarden, Tailscale daemon)
systemd/*.service,*.timer  Plain systemd units: secrets decrypt, Tailscale
                            up/serve, Borg job, one-time rpm-ostree package
                            layering, NUT config rendering
fail2ban/jail.local        Dropped in as-is once fail2ban is layered
dnscrypt-proxy/*           Dropped in as-is once dnscrypt-proxy is layered;
                            update-blocklist.sh fetches the actual blocklist
nut/*                      Dropped in as-is (two are .tmpl, rendered at boot)
                            once nut is layered
nftables/nftables.conf     SSH + NUT restricted to tailscale0
secrets/                   gitignored — only the Borg/age SSH private key
                            goes here before compiling, see "Secrets" below
```

fail2ban, dnscrypt-proxy, NUT, borgbackup, and `age` itself have no
NixOS-module-equivalent to port automatically — only their *binaries* come
from `rpm-ostree` (via `systemd/layer-packages.service`, which runs once on
first boot and reboots to activate the layer); their config/invocation is
just the plain files above, dropped in directly by Ignition. Borg and
`age` ride along on this same layer rather than a custom container image
or a hand-fetched static binary, since both are plain Fedora RPMs — no
image to build/push, no binary to track for updates yourself.

## Secrets — reused directly, no re-encryption

`secret1.age`, `secret3.age`, `secret7.age`, and `secret8.age` are
referenced **directly from the repo's existing `../secrets/` folder**,
byte-for-byte, with no re-encryption step. This works because the SSH
private key already deployed for the Borg job
(`/home/sumee/.ssh/id_ed25519`, see below) is *already* an authorized
agenix recipient for those exact files — check `secrets/agenix-rules.nix`:
`secret1`/`secret3`/`secret8` are encrypted to the `cute` group, `secret7`
to `unison` (which is a superset of `cute`), and the personal key that
ends up at `sumee`'s `~/.ssh/id_ed25519` on every host is a member of one
of those groups. `age` natively accepts `ssh-ed25519` keys as decryption
identities (that's what agenix itself relies on), so the exact same
key/ciphertext pair the live NixOS box already uses works here unchanged
— just decrypted with the standalone `age` CLI instead of `agenix`.

What's reused for what (see `systemd/decrypt-secrets.service`):
- `secret1.age` → `/run/secrets/secret1` — the Borg passphrase **and**
  both NUT user passwords. This is one shared value today (see
  `modules/hardware/ups.nix` and `hosts/verdure/configuration.nix`, both
  of which point `passwordFile`/`passCommand` at this same secret) — not
  a simplification introduced here, just preserved as-is.
- `secret3.age` → `/run/secrets/2fauth.env` — 2FAuth's env file, unchanged.
- `secret7.age` → `/run/secrets/tailscale.env` — previously Caddy's
  Tailscale auth key, reused directly for `tailscale up` now that Caddy is
  gone. The variable inside is literally named `TS_AUT` (not `TS_AUTH` —
  an existing typo baked into the live ciphertext), carried forward as-is.
- `secret8.age` → `/run/secrets/vaultwarden.env` — Vaultwarden's env file,
  unchanged (aside from the SQLite migration below).

### Before compiling

1. **Carry over the Borg SSH identity**: copy the *existing*
   `/home/sumee/.ssh/id_ed25519` (private key) from the live NixOS box to
   `coreos/secrets/id_ed25519`. `seed`'s `authorized_keys` needs zero
   changes, and this same key is what makes the secret reuse above work.
2. If you ever rotate that key independently of agenix's own rotation
   (i.e. outside of a normal `agenix -e` re-encrypt), you'd need to
   re-encrypt `secret1/3/7/8.age` against the new key too — otherwise
   leave the ciphertext untouched.

## Tailscale tagging & virtual services (do this before first boot)

The `svc:home`/`svc:auth`/`svc:vault` virtual services in
`systemd/tailscale-serve.service` only work from a **tagged** device.
In the tailnet admin console / ACL policy, before provisioning:

1. Define (or confirm) a tag, e.g. `tag:server`.
2. Grant that tag permission to advertise `svc:home`, `svc:auth`,
   `svc:vault` (via `tailscale.services` grants in the ACL policy).
3. Make sure the key inside `secret7.age` (`TS_AUT`) is valid and scoped
   to claim that tag — it's being reused as-is, so if it's expired or
   scoped only for Caddy's old purpose, generate a fresh one in the admin
   console and re-encrypt just `secret7.age` (still against the same
   existing recipients, no new keypair needed).

## Vaultwarden SQLite migration

Before first boot of `vaultwarden.container`, export the existing
Postgres data to SQLite using Vaultwarden's documented migration path
(admin-panel vault export, or a community Postgres→SQLite script),
producing `db.sqlite3`. Place it at the path that will become
`/var/lib/vaultwarden/db.sqlite3` on the new host (i.e. restore it there
after the Borg-restore step in the migration plan, §1).

## Building the image

Run from the **repo root** (not from inside `coreos/`):

```sh
butane --pretty --strict coreos/butane/verdure.bu --files-dir . > coreos/verdure.ign
coreos-installer install /dev/sdX \
  --ignition-file coreos/verdure.ign \
  --architecture aarch64 \
  --image-url <fcos-metal-aarch64.raw.xz>
```

(`--files-dir .` resolves the `contents: {local: ...}` references — some
pointing into `secrets/`, some into `coreos/...` — relative to the repo
root.)

## First-boot sequence (what actually happens)

1. `layer-packages.service` runs, layers `fail2ban dnscrypt-proxy nut
   bluez borgbackup age` via `rpm-ostree`, reboots once.
2. `decrypt-secrets.service` decrypts `secret1/3/7/8.age` into
   `/run/secrets` (tmpfs), using the now-layered `age` binary and
   `/home/sumee/.ssh/id_ed25519` as the identity.
3. `render-nut-config.service` substitutes the NUT password into
   `upsd.users`/`upsmon.conf`.
4. `tailscaled.container` starts, `tailscale-up.service` brings the node
   up as `verdure-fcos` (see note in that file about renaming to `verdure`
   at cutover).
5. `hass.container`, `2fauth.container`, `vaultwarden.container` start.
6. `tailscale-serve.service` wires up the three virtual services.
7. `update-blocklist.service` fetches StevenBlack's hosts list and
   converts it into `/etc/dnscrypt-proxy/blocklist.txt` (runs again weekly
   via `update-blocklist.timer`, `Sun 03:00:00`).
8. `fail2ban.service`, `dnscrypt-proxy.service`, `bluetooth.service`,
   `nut-server.service`, `nut-monitor.service` start (now that their
   binaries are layered).
9. `borgbackup.timer` is armed for the next `Mon 04:00:00`.

## Known placeholders left in this tree

- `--hostname=verdure-fcos` in `systemd/tailscale-up.service` (flip to
  `verdure` only at final cutover, per the migration plan §6)

Everything else (capability lists, volume paths, env vars, firewall
rules, NUT/fail2ban/dnscrypt thresholds) is a direct port of the values
already live in the NixOS flake — see the comment at the top of each file
for which `modules/*.nix` it corresponds to.
