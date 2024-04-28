#!/usr/bin/env sh

# NAME
#  install -

CMD_NAME="shell41-install"

# ╭───┤ Functions
# ╰─

# Redirect stdin from /dev/tty to ensure it's treated as interactive and not
# inherited from parent's stdin
log_error() { "$SH41_UTILS"/log "$@" "$CMD_NAME" < /dev/tty; }

# ╭───┤ Check dependencies
# ╰─

MUST_HAVE="curl git jq"

for dep in $MUST_HAVE; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    print_error "$dep is required to run this script"
    exit 2
  fi
done

# ╭───┤ Main
# ╰─
