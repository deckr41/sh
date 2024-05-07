#!/usr/bin/env sh

export SH41_HOME="$(dirname "$0")"
export SH41_ICON="󱚥"
export SH41_DEBUG=""

export SH41_LOCAL="$SH41_HOME/.local"
export SH41_CACHE="$SH41_HOME/.cache"
mkdir -p "$SH41_LOCAL" "$SH41_CACHE"

export SH41_LIB="$SH41_HOME/lib"
export SH41_BIN="$SH41_HOME/bin"
export PATH="$SH41_BIN:$PATH"
