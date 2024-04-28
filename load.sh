#!/usr/bin/env sh

export SH41_HOME="$(dirname "$0")"
export SH41_ICON="󱚥"
export SH41_DEBUG=""
export SH41_LOG_DATE_FORMAT="+%H:%M:%S"

export SH41_LOCAL="$SH41_HOME/.local"
export SH41_CACHE="$SH41_HOME/.cache"
mkdir -p "$SH41_LOCAL" "$SH41_CACHE"

export SH41_LIBS="$SH41_HOME/lib"
export SH41_PROVIDERS="$SH41_LIBS/providers"
export SH41_UTILS="$SH41_LIBS/utils"

export SH41_BIN="$SH41_HOME/bin"
export PATH="$SH41_BIN:$PATH"
