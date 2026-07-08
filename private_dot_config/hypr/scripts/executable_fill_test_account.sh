#!/bin/bash

# Create a fresh, dated Plantime test account and fill a signup form with it.
# Prompts (rofi) for a tag, then:
#   - email:  diego+<YYYYMMDD-HHMMSS>_<tag>@plantime.io
#   - pass:   generates + stores a password at business/plantime_test/<YYYYMMDD-HHMMSS>_<tag>
#   - types:  email <Tab> password  into the focused form
#   - syncs:  pulls/pushes the pass git store
# One pass entry per account, so every test login is recorded and retrievable
# later with `pass show business/plantime_test/<YYYYMMDD-HHMMSS>_<tag>`.
set -euo pipefail

# --- config ---------------------------------------------------------------
email_user="diego"
email_domain="plantime.io"
pass_dir="business/plantime_test"        # one entry per account under here
pass_len=20                              # generated password length
pass_charset='A-Za-z0-9@#%&*!?'          # safe symbols (avoid form-hostile chars)
git_ssh='ssh -o BatchMode=yes -o ConnectTimeout=10'   # fail fast, never hang
# --------------------------------------------------------------------------

note() { notify-send "test account" "$1" || true; }

# Keybind context: no terminal, so surface problems on the desktop.
for dep in rofi wtype pass; do
  command -v "$dep" >/dev/null 2>&1 || { note "missing dependency: $dep"; exit 1; }
done

# rofi exits non-zero on Esc/cancel; leave quietly without typing anything.
tag=$(rofi -dmenu -p "test account tag" -lines 0) || exit 0
tag=$(printf '%s' "$tag" | tr -cd 'A-Za-z0-9._-')   # keep it a safe slug
[[ -z "$tag" ]] && exit 0

slug="$(date +%Y%m%d-%H%M%S)_${tag}"
email="${email_user}+${slug}@${email_domain}"
entry="${pass_dir}/${slug}"

# Generate + store this account's password. No --force: refuse to clobber an
# existing entry (that would lose a prior account's password). Encryption is a
# public-key op, so this needs no passphrase.
if ! PASSWORD_STORE_CHARACTER_SET="$pass_charset" \
      pass generate "$entry" "$pass_len" >/dev/null 2>&1; then
  note "pass generate failed (does $entry already exist?)"
  exit 1
fi

# Read the password back for typing (decrypts via gpg-agent; may show a
# pinentry prompt the first time per cache window).
password=$(pass show "$entry" 2>/dev/null | head -n1) || true
if [[ -z "$password" ]]; then
  note "couldn't read back password for $entry"
  exit 1
fi

# Fill the form first (the user is waiting on it): email, Tab, password.
# `--` guards a value that starts with '-'.
wtype -- "$email"
wtype -k Tab
wtype -- "$password"

# Then sync the store, best-effort — the entry is already saved locally, and a
# failed push self-heals on the next run's pull/push.
GIT_SSH_COMMAND="$git_ssh" pass git pull --rebase --quiet 2>/dev/null || note "pass git pull failed for $entry"
GIT_SSH_COMMAND="$git_ssh" pass git push --quiet 2>/dev/null || note "pass git push failed for $entry"

note "created ${email}"
