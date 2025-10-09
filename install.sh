#!/bin/bash

# This script interactively installs either 'brokefetch.sh', 'brokefetch_beta.sh'.
# or 'brokefetch_mod.sh' from the current directory, or downloads it if not found.
# It gives the user a choice to install to /usr/bin (system-wide) or ~/.local/bin
# (user-specific). If brokefetch_mod.sh is selected, it will also clone the
# repository to get the 'logos' directory.

# --- Best practice for robust scripts: Exit immediately on errors ---
set -e

# --- Function to check for curl ---
check_curl() {
    if ! command -v curl &> /dev/null; then
        echo "Error: 'curl' is not installed. Please install it to download the script."
        echo "On Debian/Ubuntu: sudo apt-get install curl"
        echo "On Fedora/CentOS: sudo dnf install curl"
        echo "On Arch Linux: sudo pacman -S curl"
        exit 1
    fi
}

# --- Function to check for git ---
check_git() {
    if ! command -v git &> /dev/null; then
        echo "Error: 'git' is not installed. Please install it to download the logos."
        echo "On Debian/Ubuntu: sudo apt-get install git"
        echo "On Fedora/CentOS: sudo dnf install git"
        echo "On Arch Linux: sudo pacman -S git"
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
if [ ${#available_scripts[@]} -eq 0 ]; then
    echo "No brokefetch scripts found in the current directory."
    echo "Please choose a version to download and install:"
    
    select choice in "Normal" "beta" "modular" "Quit"; do
        case $REPLY in
            1 )
                echo "Downloading the normal version..."
                if curl -sSL "$NORMAL_URL" -o "$temp_dir/brokefetch.sh"; then
                    source_file="$temp_dir/brokefetch.sh"
                    script_to_install="brokefetch.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the normal version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;
            2 )
                echo "Downloading the beta version..."
                if curl -sSL "$EDGE_URL" -o "$temp_dir/brokefetch_beta.sh"; then
                    source_file="$temp_dir/brokefetch_beta.sh"
                    script_to_install="brokefetch_beta.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the beta version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;
            3 )
                echo "Downloading the beta2 version..."
                if curl -sSL "$BETA2_URL" -o "$temp_dir/brokefetch_beta2.sh"; then
                    source_file="$temp_dir/brokefetch_beta2.sh"
                    script_to_install="brokefetch_beta2.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the beta2 version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;    
            4 )
                echo "Downloading the modular version..."
                if curl -sSL "$EDGE_AC_URL" -o "$temp_dir/brokefetch_mod.sh"; then
                    source_file="$temp_dir/brokefetch_mod.sh"
                    script_to_install="brokefetch_mod.sh"
                    downloaded=1
                    break
                else
                    echo "Error: Failed to download the modular version. Exiting."
                    rm -r "$temp_dir"
                    exit 1
                fi
                ;;
            5 )
                echo "Exiting installation."
                rm -rf "$temp_dir"
                exit 0
                ;;
            * )
                echo "Invalid choice. Please select a number from the list."
                ;;
        esac
    done
# If local files were found, prompt the user to choose
elif [ ${#available_scripts[@]} -eq 1 ]; then
    source_file="${available_scripts[0]}"
    script_to_install="${available_scripts[0]}"
    echo "Found '${source_file}'. This script will be installed."
else
    echo "Multiple brokefetch scripts found. Please choose one to install:"
    select choice in "${available_scripts[@]}"; do
        if [ -n "$choice" ]; then
            source_file="$choice"
            script_to_install="$choice"
            break
        else
            echo "Invalid choice. Please select a number from the list."
        fi
    done
fi

# Exit if no source file was determined (e.g., download failed or user quit)
if [ -z "$source_file" ]; then
    echo "Error: Could not determine a source file for installation."
    rm -rf "$temp_dir"
    exit 1
fi

# --- Step 2: Ask the user for the installation path ---
echo "Where would you like to install the 'brokefetch' script?"

install_path=""
use_sudo="false"

select install_choice in "/usr/bin" "$HOME/.local/bin" "Quit"; do
    case $install_choice in
        "/usr/bin" )
            install_path="/usr/bin/brokefetch"
            use_sudo="true"
            echo "Installing to /usr/bin. You will be prompted for your password."
            break
            ;;
        "$HOME/.local/bin" )
            install_path="$HOME/.local/bin/brokefetch"
            echo "Installing to ~/.local/bin."
            break
            ;;
        "Quit" )
            echo "Installation canceled."
            if [ $downloaded -eq 1 ]; then rm -rf "$temp_dir"; fi
            exit 0
            ;;
        * )
            echo "Invalid choice. Please select 1, 2, or 3."
            ;;
    esac
done

install_dir=$(dirname "$install_path")

# --- Step 3: Check for existing installation and prompt for overwrite/remove ---
if [ -f "$install_path" ]; then
    echo "An existing 'brokefetch' script was found at $install_path."
    read -p "Do you want to overwrite it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation canceled by user."
        if [ $downloaded -eq 1 ]; then rm -rf "$temp_dir"; fi
        exit 0
    fi
fi

# --- Step 4: Perform the installation ---
echo "Installing '$script_to_install' to '$install_path'..."

# Create the directory if it doesn't exist
if [ "$use_sudo" = "true" ]; then
    sudo mkdir -p "$install_dir"
else
    mkdir -p "$install_dir"
fi

# Copy the chosen file
if [ "$use_sudo" = "true" ]; then
    sudo cp "$source_file" "$install_path"
else
    cp "$source_file" "$install_path"
fi

# Make the new file executable
if [ "$use_sudo" = "true" ]; then
    sudo chmod +x "$install_path"
else
    chmod +x "$install_path"
fi

# --- Step 5: Conditional post-installation steps for the AC version ---
if [ "$script_to_install" = "brokefetch_mod.sh" ]; then
    echo "Processing post-installation steps for brokefetch_mod.sh..."
    
    # Check if git is available
    check_git

    repo_clone_path="$temp_dir/brokefetch_repo"
    
    # IMPORTANT: The logos directory is now installed to a system-wide location.
    target_logos_dir="/usr/share/brokefetch/logos"
    
    echo "Cloning repository to get the logos folder..."
    git clone --depth 1 "$REPO_URL" "$repo_clone_path"

    echo "Copying 'logos' directory to '$target_logos_dir'..."
    # Use sudo to create the system directory and copy the files
    sudo mkdir -p "$target_logos_dir"
    sudo cp -r "$repo_clone_path/logos" "$target_logos_dir"

    # Set ownership for the user to manage their own logos.
    sudo chown -R "$(whoami):$(whoami)" "$target_logos_dir"
    echo "Successfully copied the 'logos' directory."
fi

# --- Step 6: Final success message and cleanup ---
echo "Success! '$script_to_install' is now installed as 'brokefetch'."

if [ "$use_sudo" != "true" ]; then
    echo "You may need to add '$HOME/.local/bin' to your PATH to run it from any directory."
fi

# Clean up temporary downloaded file and cloned repository
if [ $downloaded -eq 1 ]; then
    echo "Cleaning up temporary files..."
    rm -rf "$temp_dir"
fi

exit 0
