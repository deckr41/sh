#!/usr/bin/env sh

# Install script of Shell41 - An interface for solving problems together with
# Large Language Models.
# 
# DESCRIPTION
#  Download the git repository, detect and update the user's shell rc file, and
#  run the `sh41 init` command to set up the database and configuration file.
#
# ENVIRONMENT
#  HOME
#   The path to the current user's home directory
#   
#  SHELL
#   The path to the current shell executable

# ╭───────┤ Shield wall!
# ╰─

if ! command -v git > /dev/null; then
  echo "Git is required to install shell41."
  exit 1
fi

# ╭───────┤ Bootstrap
# ╰─

set -e

# Use this after cloning the repository, otherwise the log script will not be
# available.
alias log="\$HOME/.shell41/lib/_scripts/log"

SH41_HOME="$HOME/.shell41"
SH41_LOAD_PATH="$SH41_HOME/load.sh"

# ╭───────┤ Functions
# ╰─

clone_repo() {
  repo_url="https://github.com/shell41/cli.git"

  git clone --depth=1 "$repo_url" "$SH41_HOME" || {
    echo "Failed to clone the repository." >&2
    exit 1
  }
}

get_user_rc_file() {
  case "$SHELL" in
    */bash) echo "$HOME/.bashrc" ;;
    */zsh) echo "$HOME/.zshrc" ;;
    */sh|*/dash) echo "$HOME/.profile" ;;
    *) log error -v shell "$SHELL" "Unsupported shell"; exit 1 ;;
  esac
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
  if command_exists apt-get; then
    echo "apt-get"
  elif command_exists yum; then
    echo "yum"
  elif command_exists brew; then
    echo "brew"
  elif command_exists pacman; then
    echo "pacman"
  else
    echo "unsupported"
  fi
}

install_dependencies() {
  dependencies="fzf curl jq bat"
  pkg_manager=$(detect_package_manager)

  case "$pkg_manager" in
    apt-get) sudo apt-get update; sudo apt-get install -y $dependencies ;;
    yum) sudo yum install -y $dependencies ;;
    brew) brew install $dependencies ;;
    pacman) sudo pacman -Sy --noconfirm $dependencies ;;
  esac
}

update_shell_rc() {
  rc_file=$(get_user_rc_file)

  if [ ! -e "$rc_file" ]; then
    log warn -v rc_file "$rc_file" -v shell "$SHELL" \
      "Shell rc file not found, creating one..."
    touch "$rc_file"
  fi

  if ! grep -q "source $SH41_LOAD_PATH" "$rc_file"; then
    {
      echo ""
      echo "# shell41 initialization"
      echo "source $SH41_LOAD_PATH"
    } >> "$rc_file"
  else
    log info \
      -v rc_file "$rc_file" -v shell "$SHELL" \
      "shell41 is already sourced in the rc file."
  fi
}

# ╭───────┤ Main 
# ╰─

if [ -d "$SH41_HOME" ]; then
  log info \
    -v install_dir "$SH41_HOME" \
    -v upgrade_command "sh41 upgrade" \
    "shell41 is already installed, use upgrade command instead."
  exit 0
fi

clone_repo
update_shell_rc
"$HOME/.shell41/bin/sh41" init 

log info "Installation complete. Please restart your shell or run 'source $HOME/.shell41/load.sh' to start using shell41." 
