#!/usr/bin/env bash
# brokefetch_installer_improved.sh
# Improved interactive installer for brokefetch variants
# - adds logging
# - attempts to install 'dialog' automatically if missing (detects distro and prompts)
# - improved distro detection: uses ID, ID_LIKE, and a custom alias map (e.g. 'aser' -> 'arch')
# - fixed dialog typos, case/break bugs
# - unified install paths and logo handling (user vs system)
# - robust error handling, cleanup trap, clear messages

set -euo pipefail
IFS=$'
	'

SCRIPT_NAME="brokefetch_installer_improved.sh"
BACKTITLE="Brokefetch installer"
TEMP_DIR=$(mktemp -d)
trap 'rc=$?; rm -rf "$TEMP_DIR" >/dev/null 2>&1 || true; exit "$rc"' EXIT

# --- Defaults / URLs (edit if upstream moves) ---
NORMAL_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch.sh"
EDGE_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_beta.sh"
BETA2_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_beta2.sh"
MOD_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_mod.sh"
REPO_URL="https://github.com/Szerwigi1410/brokefetch.git"

# --- Logging setup ---
LOG_DIR_USER="$HOME/.cache/brokefetch_installer"
mkdir -p "$LOG_DIR_USER"
LOG_FILE_USER="$LOG_DIR_USER/installer.log"
LOG_FILE="$LOG_FILE_USER"

log() {
  printf "%s %s
" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "$*" | tee -a "$LOG_FILE"
}

run_and_log() {
  log "+ Running: $*"
  ( $* ) 2>&1 | tee -a "$LOG_FILE"
}

# --- Helpers to detect/normalize distro ---
# Returns a normalized distro id (debian|ubuntu|fedora|centos|arch|void|alpine|unknown)
detect_and_normalize_distro() {
  local id="unknown"
  local id_like=""
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    id="${ID:-unknown}"
    id_like="${ID_LIKE:-}"
  fi

  # quick alias map for custom distro IDs
  declare -A alias_map=( [aser]=arch [aserlinux]=arch [archlinux]=arch [manjaro]=arch )
  if [[ -n "${alias_map[$id]:-}" ]]; then
    echo "${alias_map[$id]}"
    return 0
  fi

  # check ID_LIKE for hint
  if [[ -n "$id_like" ]]; then
    # split id_like and prefer known families
    for part in $id_like; do
      case "$part" in
        debian) echo debian; return 0;;
        ubuntu) echo debian; return 0;;
        rhel|fedora|centos) echo fedora; return 0;;
        arch) echo arch; return 0;;
        alpine) echo alpine; return 0;;
        void) echo void; return 0;;
      esac
    done
  fi

  # fallback: normalize some common IDs
  case "$id" in
    debian|ubuntu|pop|linuxmint) echo debian; return 0;;
    fedora|rhel|centos) echo fedora; return 0;;
    arch|archlinux|manjaro) echo arch; return 0;;
    alpine) echo alpine; return 0;;
    void) echo void; return 0;;
  esac

  echo unknown
}

install_dialog_via_pkgmanager() {
  local distro="$1"
  case "$distro" in
    debian)
      run_and_log sudo apt-get update && run_and_log sudo apt-get install -y dialog
      ;;
    fedora)
      run_and_log sudo dnf install -y dialog
      ;;
    centos|rhel)
      run_and_log sudo yum install -y dialog
      ;;
    arch)
      run_and_log sudo pacman -Sy --noconfirm dialog
      ;;
    void)
      run_and_log sudo xbps-install -Sy dialog
      ;;
    alpine)
      run_and_log sudo apk add dialog
      ;;
    *)
      return 1
      ;;
  esac
}

fallback_prompt_install_dialog() {
  log "'dialog' not found. Attempting to detect distro."
  detected_raw="unknown"
  if [ -f /etc/os-release ]; then . /etc/os-release; detected_raw="${ID:-unknown}"; fi
  detected=$(detect_and_normalize_distro)
  log "Raw ID=$detected_raw normalized->$detected"

  if [ "$detected" != "unknown" ]; then
    # tell user what we think and ask
    echo "Detected distro (raw ID): $detected_raw"
    echo "Normalized to: $detected"
    read -rp "Install 'dialog' now using the package manager for '$detected'? [y/N]: " yn
    case "$yn" in
      [Yy]*)
        if install_dialog_via_pkgmanager "$detected"; then
          log "Successfully installed dialog via detected distro: $detected"
        else
          log "Automatic install failed for normalized distro: $detected"
          echo "Automatic install failed. You may install 'dialog' manually and re-run this installer."
          exit 1
        fi
        ;;
      *)
        echo "Okay — please install 'dialog' manually and re-run this installer.";
        exit 1
        ;;
    esac
  else
    echo "Couldn't detect a supported distro automatically. Choose one from the list or install 'dialog' manually."
    PS3="Select your distro (or 0 to cancel): "
    options=("debian/ubuntu" "fedora" "centos/rhel" "arch/manjaro" "void" "alpine" "Cancel")
    select opt in "${options[@]}"; do
      case "$REPLY" in
        1) install_dialog_via_pkgmanager debian && break ;;
        2) install_dialog_via_pkgmanager fedora && break ;;
        3) install_dialog_via_pkgmanager centos && break ;;
        4) install_dialog_via_pkgmanager arch && break ;;
        5) install_dialog_via_pkgmanager void && break ;;
        6) install_dialog_via_pkgmanager alpine && break ;;
        7) echo "Canceled."; exit 1 ;;
        *) echo "Invalid choice." ;;
      esac
    done
  fi

  if command -v dialog &>/dev/null; then
    log "dialog is now available"
  else
    log "dialog still missing after attempted install"
    echo "dialog is still not installed. Install it manually and re-run the installer.";
    exit 1
  fi
}

# --- Ensure dialog is available (with fallback installer) ---
if ! command -v dialog &>/dev/null; then
  fallback_prompt_install_dialog
fi

log "Starting installer (dialog available)."

dialog --clear --backtitle "$BACKTITLE" --title "Warning" \
  --yesno "This installer is experimental and may contain bugs.
You are responsible for using it.

Proceed?" 10 60
if [ $? -ne 0 ]; then
  clear
  log "User aborted at warning prompt."
  echo "Aborted by user.";
  exit 0
fi
clear

# Find local candidates
available_scripts=()
for f in brokefetch.sh brokefetch_beta.sh brokefetch_beta2.sh brokefetch_mod.sh; do
  [ -f "$f" ] && available_scripts+=("$f")
done

# If none present, offer to download
downloaded=0
source_file=""
script_to_install=""

if [ ${#available_scripts[@]} -eq 0 ]; then
  if ! command -v curl &>/dev/null; then
    dialog --clear --title "Missing dependency" --backtitle "$BACKTITLE" \
      --msgbox "Error: 'curl' is required to download remote versions.
Please install 'curl' and re-run." 10 60
    clear
    exit 1
  fi

  choice=$(dialog --clear --title "Choose Brokefetch to download" --backtitle "$BACKTITLE" --menu "Select a version to download:" 15 60 6 \
    1 "Normal" \
    2 "Beta" \
    3 "Beta2" \
    4 "Modular" \
    5 "Quit" 3>&1 1>&2 2>&3) || true
  clear

  case "$choice" in
    1)
      url="$NORMAL_URL"; name="brokefetch.sh" ;;
    2)
      url="$EDGE_URL"; name="brokefetch_beta.sh" ;;
    3)
      url="$BETA2_URL"; name="brokefetch_beta2.sh" ;;
    4)
      url="$MOD_URL"; name="brokefetch_mod.sh" ;;
    *)
      echo "Canceled."; exit 0 ;;
  esac

  tmpfile="$TEMP_DIR/$name"
  log "Downloading $name from $url"
  if curl -fSL --progress-bar "$url" -o "$tmpfile"; then
    source_file="$tmpfile"
    script_to_install="$name"
    downloaded=1
    log "Downloaded $name to $tmpfile"
  else
    dialog --clear --title "Download failed" --backtitle "$BACKTITLE" --msgbox "Failed to download $name.
Please check your network or the URL." 8 60
    clear
    log "Download failed for $url"
    exit 1
  fi

elif [ ${#available_scripts[@]} -eq 1 ]; then
  source_file="${available_scripts[0]}"
  script_to_install="${available_scripts[0]}"
  dialog --clear --title "Found script" --backtitle "$BACKTITLE" --msgbox "Found '${source_file}' in the current directory. It will be installed." 8 60
  clear
else
  menu_args=()
  for s in "${available_scripts[@]}"; do
    menu_args+=("$s" "")
  done
  choice=$(dialog --clear --title "Select script to install" --backtitle "$BACKTITLE" --menu "Multiple brokefetch scripts found. Choose one:" 15 60 6 "${menu_args[@]}" 3>&1 1>&2 2>&3) || true
  clear
  if [ -z "$choice" ]; then
    echo "No selection made. Exiting."; exit 1
  fi
  source_file="$choice"
  script_to_install="$choice"
fi

if [ ! -f "$source_file" ]; then
  dialog --clear --title "Error" --backtitle "$BACKTITLE" --msgbox "Source file not found: $source_file" 8 60
  clear
  log "Source file missing after selection: $source_file"
  exit 1
fi

install_choice=$(dialog --clear --title "Choose install path" --backtitle "$BACKTITLE" --menu "Install to:" 12 60 4 \
  1 "/usr/bin (system-wide)" \
  2 "$HOME/.local/bin (user)" \
  3 "Cancel" 3>&1 1>&2 2>&3) || true
clear

case "$install_choice" in
  1)
    install_path="/usr/bin/brokefetch"
    install_scope="system"
    ;;
  2)
    install_path="$HOME/.local/bin/brokefetch"
    install_scope="user"
    ;;
  *)
    echo "Canceled."; exit 0;;
esac

install_dir=$(dirname "$install_path")

if [ "$install_scope" = "system" ]; then
  LOG_FILE="/var/log/brokefetch_installer.log"
  if ! sudo test -d /var/log; then
    sudo mkdir -p /var/log
  fi
  if ! sudo test -f "$LOG_FILE"; then
    sudo touch "$LOG_FILE"
    sudo chown "$(whoami):$(whoami)" "$LOG_FILE"
  fi
  log "Using system log file at $LOG_FILE"
else
  LOG_FILE="$LOG_FILE_USER"
  log "Using user log file at $LOG_FILE"
fi

if [ "$install_scope" = "system" ]; then
  if ! command -v sudo &>/dev/null; then
    dialog --clear --title "Missing sudo" --backtitle "$BACKTITLE" --msgbox "Installing system-wide requires 'sudo'.
Please install sudo or run this script as root." 8 60
    clear
    log "sudo missing on system install";
    exit 1
  fi
  dialog --clear --title "Privilege" --backtitle "$BACKTITLE" --msgbox "You will be asked for your password to install to $install_dir." 7 60
  clear
  run_and_log sudo mkdir -p "$install_dir"
else
  mkdir -p "$install_dir"
fi

if [ -f "$install_path" ]; then
  dialog --clear --title "Overwrite" --backtitle "$BACKTITLE" --yesno "A file exists at $install_path. Overwrite?" 7 60
  if [ $? -ne 0 ]; then
    clear; log "User canceled overwrite."; echo "Installation cancelled."; exit 0
  fi
fi

{
  for i in $(seq 1 100); do
    sleep 0.01
    printf "%d
" "$i"
  done
} | dialog --title "Installing" --backtitle "$BACKTITLE" --gauge "Installing $script_to_install to $install_path..." 8 60 0

if [ "$install_scope" = "system" ]; then
  run_and_log sudo cp -f "$source_file" "$install_path"
  run_and_log sudo chmod 0755 "$install_path"
else
  run_and_log cp -f "$source_file" "$install_path"
  run_and_log chmod 0755 "$install_path"
fi

if [[ "$script_to_install" == *"mod"* || "$script_to_install" == "brokefetch_mod.sh" ]]; then
  if [ "$install_scope" = "system" ]; then
    target_logos_dir="/usr/share/brokefetch/logos"
    run_and_log sudo mkdir -p "$target_logos_dir"
    run_and_log git clone --depth 1 "$REPO_URL" "$TEMP_DIR/brokefetch_repo"
    if [ -d "$TEMP_DIR/brokefetch_repo/logos" ]; then
      run_and_log sudo cp -r "$TEMP_DIR/brokefetch_repo/logos" "$target_logos_dir"
      run_and_log sudo chown -R "$(whoami):$(whoami)" "$target_logos_dir"
      log "Copied logos to $target_logos_dir"
    else
      dialog --clear --title "Warning" --backtitle "$BACKTITLE" --msgbox "Warning: logos directory not found in repo." 8 60
      clear
      log "logos dir not found in cloned repo"
    fi
  else
    target_logos_dir="$HOME/.local/share/brokefetch/logos"
    mkdir -p "$(dirname "$target_logos_dir")"
    run_and_log git clone --depth 1 "$REPO_URL" "$TEMP_DIR/brokefetch_repo"
    if [ -d "$TEMP_DIR/brokefetch_repo/logos" ]; then
      run_and_log cp -r "$TEMP_DIR/brokefetch_repo/logos" "$target_logos_dir"
      log "Copied logos to $target_logos_dir"
    else
      dialog --clear --title "Warning" --backtitle "$BACKTITLE" --msgbox "Warning: logos directory not found in repo." 8 60
      clear
      log "logos dir not found in cloned repo"
    fi
  fi
fi

if [ "$install_scope" = "user" ]; then
  if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
    dialog --clear --title "Add to PATH" --backtitle "$BACKTITLE" --msgbox "Note: $HOME/.local/bin is not on your PATH.
Add it to run 'brokefetch' from any directory.

Example: add to ~/.profile or ~/.bashrc:

  export PATH=\"\$HOME/.local/bin:\$PATH\"" 12 70
    clear
  fi
fi

dialog --clear --title "Done" --backtitle "$BACKTITLE" --msgbox "Success! Installed '$script_to_install' to '$install_path'.
Log file: $LOG_FILE" 9 70
clear

log "Installation complete. script=$script_to_install path=$install_path"

echo "Installation complete. Log: $LOG_FILE"; exit 0
