#!/bin/bash

# This script interactively installs either 'brokefetch.sh', 'brokefetch_beta.sh'.
# or 'brokefetch_mod.sh' from the current directory, or downloads it if not found.
# It gives the user a choice to install to /usr/bin (system-wide) or ~/.local/bin
# (user-specific). If brokefetch_mod.sh is selected, it will also clone the
# repository to get the 'logos' directory.

# --- Best practice for robust scripts: Exit immediately on errors ---
#set -e

# --- Function to check for curl ---
check_curl() {
    if ! command -v curl &> /dev/null; then
        dialog --clear \
        --title "Error" \
        --backtitle "Brokefetch Installer" \
        --msgbox "Error: 'curl' is not installed. Please install it to download the script.

        On Debian/Ubuntu: sudo apt-get install curl
        On Fedora/CentOS: sudo dnf install curl
        On Arch Linux: sudo pacman -S curl" 10 55
        clear
        exit 1
    fi
}

# --- Function to check for git ---
check_git() {
    if ! command -v git &> /dev/null; then
        dialog --clear \
        --title "Error" \
        --backtitle "Brokefetch Installer" \
        --msgbox "Error: 'git' is not installed. Please install it to download the script.

        On Debian/Ubuntu: sudo apt-get install git
        On Fedora/CentOS: sudo dnf install git
        On Arch Linux: sudo pacman -S git" 10 55
        clear
        exit 1
    fi
}

# --- Define download URLs ---
# These URLs should point to the raw files in your GitHub repository.
NORMAL_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch.sh"
EDGE_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_beta.sh"
BETA2_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_beta2.sh"
EDGE_AC_URL="https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/brokefetch_mod.sh"
REPO_URL="https://github.com/Szerwigi1410/brokefetch.git"

# --- Main script execution starts here ---

# Check for necessary tools first
check_curl

# --- Step 1: Identify and/or download the source file ---
source_file=""
downloaded=0
temp_dir=$(mktemp -d)
script_to_install=""

# Check for existing local files
available_scripts=()
if [ -f "brokefetch.sh" ]; then
    available_scripts+=("brokefetch.sh")
fi
if [ -f "brokefetch_beta.sh" ]; then
    available_scripts+=("brokefetch_beta.sh")
fi
if [ -f "brokefetch_beta2.sh" ]; then
    available_scripts+=("brokefetch_beta2.sh")
fi
if [ -f "brokefetch_mod.sh" ]; then
    available_scripts+=("brokefetch_mod.sh")
fi

# If no local files found, prompt to download
    #under contruction