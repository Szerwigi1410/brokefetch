#!/bin/bash

# This script automatically formats the ASCII art and system information
# to ensure there is a consistent space between them, no matter the length
# of the ASCII art lines.

# IMPORTANT NOTE: This script is called "brokefetch_EDGE.sh" because it is not fully functional yet.
# It is a work in progress. When completed, it will replace "brokefetch.sh".
# This script will display different ASCII for each OS and do many other useful stuff which brokefetch.sh doesn't support yet.

# --- CONFIGURATION ---
CONFIG_FILE="$HOME/.config/brokefetch/config"
ASCII_DIR="$HOME/.config/brokefetch/logos"

# Create default config if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo -e "# Available COLOR_NAME options: RED, GREEN, BLUE, CYAN, WHITE" > "$CONFIG_FILE"
	echo -e "# Set RAM_MB to your desired memory size in MB" >> "$CONFIG_FILE"
	echo -e "# Set UPTIME_OVERRIDE to your desired uptime in hours" >> "$CONFIG_FILE"
	echo -e "RAM_MB=128\nUPTIME_OVERRIDE=16h\nCOLOR_NAME=CYAN" >> "$CONFIG_FILE"
fi

# Load values from the config file
source "$CONFIG_FILE"

# Create logos directory if it doesn't exist
if [[ ! -d "$ASCII_DIR" ]]; then
    mkdir -p "$ASCII_DIR"
fi

# Array to hold the ASCII art lines
declare -a ASCII_ART_LINES

# A flag to check if we should enable colors
COLOR_MODE=false

# Define color variables conditionally, initialized to empty strings
GREEN=""
RED=""
BLUE=""
CYAN=""
WHITE=""
YELLOW=""
PURPLE=""
BOLD=""
RESET=""

# --- FUNCTIONS ---
# Function to load ASCII art from a file
load_ascii() {
    local file_path="$ASCII_DIR/$1.txt"
    # Clear the previous ASCII art
    ASCII_ART_LINES=()

    if [[ -f "$file_path" ]]; then
        # Read the file line by line into the array
        mapfile -t ASCII_ART_LINES < "$file_path"
        return 0
    else
        return 1
    fi
}

# Function to get the correct ASCII file name from a detected OS name
get_ascii_filename() {
    local os_name_lower=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    local filename=""

    # Case for specific distros with non-standard file names
    case "$os_name_lower" in
        "arch linux") filename="arch" ;;
        "debian gnu/linux") filename="debian" ;;
        "linux mint") filename="linuxmint" ;;
        "linux lite") filename="linuxlite" ;;
        "red hat enterprise linux") filename="rhel" ;;
        "ubuntu") filename="ubuntu" ;;
        "fedora linux") filename="fedora" ;;
        "void linux") filename="void" ;;
        "windows 11") filename="windows_11" ;;
        # Add other specific cases here
        *)
            # Default behavior: remove spaces and convert to lowercase
            filename=$(echo "$os_name_lower" | tr -d ' ')
            ;;
    esac
    echo "$filename"
}

# --- SYSTEM INFORMATION GATHERING ---
# Package count
if command -v pacman &>/dev/null; then
    PKG_COUNT=$(pacman -Q | wc -l)
elif command -v dpkg &>/dev/null; then
    PKG_COUNT=$(dpkg -l | grep '^ii' | wc -l)
elif command -v rpm &>/dev/null; then
    PKG_COUNT=$(rpm -qa | wc -l)
elif command -v apk &>/dev/null; then
    PKG_COUNT=$(apk info | wc -l)
elif command -v pkg &>/dev/null; then
    PKG_COUNT=$(pkg info | wc -l)
else
    PKG_COUNT="-1" # Unknown package manager
fi

# OS
if [ -f /etc/os-release ]; then
    # linux
    OS_NAME="$(awk -F= '/^NAME=/{print $2}' /etc/os-release | tr -d '"')"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    OS_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    OS_NAME="Android"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            OS_NAME="macOS"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            OS_NAME="Windows"
            ;;
        *)
            # A new fallback case for unknown OS
            OS_NAME="Generic Linux"
            ;;
    esac
fi


case "$OS_NAME" in
    "Adelie Linux")        OS="Adelie Linux (Are you a Action Retro?)";;
    "Aeon")                OS="Aeon (Bro wth is that, just use something normal)";;
    "Aeros")               OS="Aeros (air-os, as in, a lot of air in my wallet)";;
    "Afterglow")           OS="Afterglow (the afterglow of my last paycheck)";;
    "AIX")                 OS="AIX (I don't even know what this is, probably expensive)";;
    "AlmaLinux")           OS="AlmaLinux (I can't believe it's not CentOS)";;
    "Alpine Linux")        OS="Alpine (because I can't afford a mountain)";;
    "Alter")               OS="Alter (I just met her)";;
    "ALT Linux")           OS="ALT Linux (just don't do it)";;
    "Amazon Linux")        OS="Amazon (sold my data to afford this)";;
    "Amazon")              OS="Amazon (prime debt)";;
    "AmogOS")              OS="AmogOS (sus, like my bank account)";;
    "Anarchy Linux")       OS="Anarchy (like my financial situation)";;
    "Android")             OS="Android (my phone is smarter than me)";;
    "Anduinos")            OS="Anduinos (and you know I'm broke)";;
    "Antergos")            OS="Antergos (The one that got away)";;
    "antiX")               OS="antiX (because I'm anti-rich)";;
    "AnushOS")             OS="AnushOS (I'm a little shy about my financial situation)";;
    "AOSC OS/Retro")       OS="AOSC OS/Retro (so old, like my savings)";;
    "AOSC OS")             OS="AOSC OS (AOSC stands for 'Absolutely Out of Cash')";;
    "Aperture OS")         OS="Aperture OS (the cake is a lie)";;
    "Apricity OS")         OS="Apricity (frozen like my bank account)";;
    "Arch Linux")          OS="Arch Linux (Unpaid Edition)";;
    "ArchBox")             OS="ArchBox (just another arch, just another debt)";;
    "Archcraft")           OS="Archcraft (Arch for gamers, but no games)";;
    "ArchLabs")            OS="ArchLabs (I laboured on this, and all I got was debt)";;
    "ArchStrike")          OS="ArchStrike (striking out with my finances)";;
    "ArcoLinux")           OS="ArcoLinux (rainbows of regret)";;
    "Arkane")              OS="Arkane (ark-a-ne-more-money-please)";;
    "Armbian")             OS="Armbian (running on a potato)";;
    "Arselinux")           OS="Arselinux (as in, 'Arse-I'm broke')";;
    "Artix Linux")         OS="Artix (SystemD-broke-my-wallet-too)";;
    "Arya")                OS="Arya (a girl has no money)";;
    "Asahi Linux")         OS="Asahi (but no money for an M1 Mac)";;
    "AsteroidOS")          OS="AsteroidOS (a little space rock, a lot of debt)";;
    "Aster")               OS="Aster (astronomically broke)";;
    "AstOS")               OS="AstOS (astounding lack of cash)";;
    "Astra Linux")         OS="Astra Linux (reaching for the stars, but my wallet's in a black hole)";;
    "AthenaOS")            OS="AthenaOS (the goddess of wisdom, but not money)";;
    "Aurora")              OS="Aurora (a beautiful light, an empty wallet)";;
    "AxOS")                OS="AxOS (I ax-ed my budget)";;
    "AzOS")                OS="AzOS (as in, 'A-Z of being broke')";;
    "Bedrock Linux")       OS="Bedrock (like my financial stability)";;
    "BigLinux")            OS="BigLinux (big dreams, small wallet)";;
    "Bitrig")              OS="Bitrig (a bit of a rigmarole to pay for this)";;
    "BlackArch")           OS="BlackArch (too cool to be in my bank account)";;
    "Black Mesa")          OS="Black Mesa (I'm a silent protagonist in my financial crisis)";;
    "Black Panther OS")    OS="Black Panther OS (Wakanda forever... but my money is gone)";;
    "BLAG")                OS="BLAG (as in, 'Blah, I'm broke')";;
    "BlankOn")             OS="BlankOn (my bank statement is blank on money)";;
    "BlueLight OS")        OS="BlueLight (the blue light of my overdue notice)";;
    "Bodhi Linux")         OS="Bodhi (enlightenment without a dollar)";;
    "Bonsai Linux")        OS="Bonsai Linux (a tiny tree, a tiny bank account)";;
    "BredOS")              OS="BredOS (bred for poverty)";;
    "BSD")                 OS="BSD (Better Save Dollars)";;
    "BunsenLabs")          OS="BunsenLabs (burning money for science)";;
    "CachyOS")             OS="CachyOS (fast, but my money disappeared faster)";;
    "Calculate Linux")     OS="Calculate (my debt, not my performance)";;
    "CalinixOS")           OS="CalinixOS (calmly going broke)";;
    "Carbs Linux")         OS="Carbs (because I can't afford protein)";;
    "CBL-Mariner")         OS="CBL-Mariner (sailing the seas of debt)";;
    "CelOS")               OS="CelOS (cellular debt)";;
    "Center OS")           OS="Center (the center of my financial struggle)";;
    "CentOS Linux")        OS="CentOS (no support, no money)";;
    "Cereus")              OS="Cereus (seriously broke)";;
    "Chakra")              OS="Chakra (aligned with my poverty)";;
    "ChaletOS")            OS="ChaletOS (a chalet I can't afford)";;
    "Chapeau")             OS="Chapeau (tipping my hat to my creditors)";;
    "Chimera Linux")       OS="Chimera (a mythological OS, like my financial freedom)";;
    "ChonkySealOS")        OS="ChonkySealOS (chonky debt)";;
    "Chromium OS")         OS="Chromium OS (less money than Google)";;
    "CleanJaro")           OS="CleanJaro (clean out my bank account)";;
    "Clear Linux OS")      OS="Clear Linux (it's clear I'm broke)";;
    "ClearOS")             OS="ClearOS (it's clear I'm broke)";;
    "Clover")              OS="Clover (bad luck with money)";;
    "Cobalt")              OS="Cobalt (a nice color, but not my bank account's)";;
    "Codex")               OS="Codex (a code for being broke)";;
    "Condres OS")          OS="Condres (con-dres-sed my money into nothing)";;
    "Cosmic OS")           OS="Cosmic (cosmic-ally broke)";;
    "CRUX")                OS="CRUX (crucial to my poverty)";;
    "Crystal Linux")       OS="Crystal Linux (a clear view of my empty wallet)";;
    "Cucumber OS")         OS="Cucumber OS (cool as a cucumber, but with no money)";;
    "Cuerdos Linux")       OS="Cuerdos (cordially broke)";;
    "CutefishOS")          OS="CutefishOS (the debt is not cute)";;
    "CuteOS")              OS="CuteOS (the debt is not cute)";;
    "CyberOS")             OS="CyberOS (cyber-broke)";;
    "Cycledream")          OS="Cycledream (cycling through my debt)";;
    "dahliaOS")            OS="dahliaOS (blooming debt)";;
    "DarkOS")              OS="DarkOS (a dark financial situation)";;
    "Debian GNU/Linux")    OS="Plebian 12 (brokeworm)";;
    "Deepin")              OS="Deepin (deep in debt)";;
    "DesaOS")              OS="DesaOS (I desa-ved a better bank account)";;
    "Devuan GNU/Linux")    OS="Devuan (D-Debt, not SystemD)";;
    "DietPi")              OS="DietPi (on a strict budget)";;
    "Draco's")             OS="Draco's (dragon hoarding gold, but not for me)";;
    "DragonFly BSD")       OS="DragonFly (flying straight into debt)";;
    "Drauger OS")          OS="Drauger (an undead OS)";;
    "Droidian")             OS="Droidian (the droids you are looking for... but I'm looking for money)";;
    "Elbrus")              OS="Elbrus (I climbed a mountain of debt for this)";;
    "elementary OS")       OS="elementaryOS (baby's first macbook)";;
    "Elive")               OS="Elive (barely alive financially)";;
    "EncryptOS")           OS="EncryptOS (my money is encrypted with debt)";;
    "EndeavourOS")         OS="EndeavourOS (Arch for fetuses)";;
    "Endless OS")          OS="Endless (like my debt)";;
    "Enso")                OS="Enso (the circle of life... and debt)";;
    "EshanizedOS")         OS="EshanizedOS (I'm a fan of this, but not my bank account)";;
    "EuroLinux")           OS="EuroLinux (euro-poverty)";;
    "EvolutionOS")         OS="EvolutionOS (evolving my debt)";;
    "EweOS")               OS="EweOS (ewww, my bank account)";;
    "Exherbo")             OS="Exherbo (too rare for my wallet)";;
    "Exodia Predator")     OS="Exodia Predator (my wallet's predator)";;
    "Fastfetch")           OS="Fastfetch (faster than my paycheck)";;
    "Fedora CoreOS")       OS="Fedora CoreOS (a core of debt)";;
    "Fedora Kinoite")      OS="Fedora Kinoite (a knight in debt)";;
    "Fedora Sericea")      OS="Fedora Sericea (seri-ously broke)";;
    "Fedora Silverblue")   OS="Fedora Silverblue (silver-less and broke)";;
    "Fedora Linux")        OS="Fedora (tips hat in poverty)";;
    "FemboyOS")            OS="FemboyOS (fiercely broke)";;
    "Feren OS")            OS="Feren OS (feren-tly broke)";;
    "Filotimo")            OS="Filotimo (a love of honor, not money)";;
    "Finnix")              OS="Finnix (fleeing my debt)";;
    "Floflis")             OS="Floflis (flow-of-money-is-not-happening)";;
    "FreeBSD")             OS="FreeBSD (Free software, broke user)";;
    "FreeMint")            OS="FreeMint (free, but I still can't afford it)";;
    "Frugalware")          OS="Frugalware (being frugal is my only choice)";;
    "Funtoo Linux")        OS="Funtoo (fun to use, not to pay for)";;
    "Furreto")              OS="Furreto (furiously broke)";;
    "GalliumOS")            OS="GalliumOS (galling)";;
    "Garuda Linux")         OS="Garuda (because RGB broke my wallet)";;
    "Gentoo")               OS="Gentoo (Because I can't even afford time)";;
    "GhostBSD")             OS="GhostBSD (haunting my bank account)";;
    "Ghostfreak")           OS="Ghostfreak (a ghost of a chance)";;
    "Glaucus")              OS="Glaucus (glaucous-ly broke)";;
    "gNewSense")            OS="gNewSense (a new sense of poverty)";;
    "GNOME")                OS="GNOME (no money)";;
    "GNU")                  OS="GNU (GNU is not Unix, but also not money)";;
    "GoboLinux")            OS="GoboLinux (everything is a file... including my debt)";;
    "Golden Dog Linux")     OS="Golden Dog Linux (a golden dog... that I can't afford)";;
    "GrapheneOS")           OS="GrapheneOS (secure, but my bank account is not)";;
    "Grombyang")            OS="Grombyang (grombyang-ly broke)";;
    "GNU Guix")             OS="GNU Guix (all-powerful, but not over my finances)";;
    "Haiku")                OS="Haiku (a five-seven-five-syllable OS of sadness)";;
    "Hamonikr")             OS="Hamonikr (harmoniously broke)";;
    "Hardclanz")            OS="Hardclanz (hard-clenched wallet)";;
    "HarmonyOS")            OS="HarmonyOS (my life is not in harmony)";;
    "Hash")                 OS="Hash (a hash of my bank account)";;
    "HCE")                  OS="HCE (horribly crushed earnings)";;
    "HeliumOS")             OS="HeliumOS (lightweight, like my wallet)";;
    "Huayra GNU/Linux")     OS="Huayra (my wallet's a whirlwind of nothing)";;
    "Hybrid")               OS="Hybrid (a hybrid of poverty and more poverty)";;
    "Hydrapwk")             OS="Hydrapwk (hydro-power... but I can't pay the electric bill)";;
    "HydroOS")              OS="HydroOS (water-logged finances)";;
    "Hyperbola GNU/Linux-libre") OS="Hyperbola (hyper-broke)";;
    "HyprOS")               OS="HyprOS (hyper broke)";;
    "Iglunix")              OS="Iglunix (igloo-cold finances)";;
    "InstantOS")            OS="InstantOS (instantly broke)";;
    "Interix")              OS="Interix (inter-ested in my debt?)";;
    "IRIX")                 OS="IRIX (an old dinosaur, like my savings)";;
    "Ironclad")             OS="Ironclad (iron-clad debt)";;
    "ITCLinux")             OS="ITCLinux (I Totally Can't afford it)";;
    "JanusLinux")           OS="JanusLinux (two-faced, like my financial situation)";;
    "Kaisen Linux")         OS="Kaisen Linux (always improving my debt)";;
    "Kali Linux")           OS="Kali Linux (Dollar Store hacker addition)";;
    "Kalpa Desktop")        OS="Kalpa Desktop (a long period of poverty)";;
    "KaOS")                 OS="KaOS (my finances are in chaos)";;
    "KDE Linux")            OS="KDE Linux (K-Debt Edition)";;
    "KDE neon")             OS="KDE neon (bright colors, dark financial situation)";;
    "KernelOS")             OS="KernelOS (the core of my problems)";;
    "Kibojoe")              OS="Kibojoe (kicking my debt)";;
    "KISS")                 OS="KISS (Keep It Simple, Stupid... like my bank balance)";;
    "Kogaion")              OS="Kogaion (don't know what it is, probably expensive)";;
    "Korora")               OS="Korora (spinning into debt)";;
    "KrassOS")              OS="KrassOS (crassly broke)";;
    "KSLinux")              OS="KSLinux (I'm a K.S. - Kinda Sad)";;
    "Kubuntu")              OS="Kubuntu (K-Ubuntu, but K-money)";;
    "Kylin Linux")          OS="Kylin (a mythical creature, like my wealth)";;
    "LainOS")               OS="LainOS (let's all get broke together)";;
    "LangitKetujuh")        OS="LangitKetujuh (seventh heaven of poverty)";;
    "Laxeros")              OS="Laxeros (lax in my spending)";;
    "LEDE")                 OS="LEDE (my finances led me to this)";;
    "LFS")                  OS="LFS (Linux for Frugal Sysadmins)";;
    "LibreELEC")            OS="LibreELEC (liberally broke)";;
    "Lilidog")              OS="Lilidog (I'm a lil' broke)";;
    "Lingmo")               OS="Lingmo (my money has no lingua)";;
    "Linsire")              OS="Linsire (inspiring poverty)";;
    "Linux Lite")           OS="Linux Lite (my distro is as light as my wallet)";;
    "Linux Mint")           OS="Linux Mint (but no teeth left)";;
    "Linux")                OS="Linux (the original broke OS)";;
    "Live Raizo")           OS="Live Raizo (living life broke)";;
    "lliurex")              OS="lliurex (I'm sure it's expensive)";;
    "LMDE")                 OS="LMDE (Linux Mint Debt Edition)";;
    "LocOS")                OS="LocOS (locked into debt)";;
    "Lubuntu")              OS="Lubuntu (lightweight, like my paycheck)";;
    "Lunar Linux")          OS="Lunar Linux (my bank account's in a different orbit)";;
    "macOS")                OS="macOS (I sold a kidney)";;
    "Mageia")               OS="Mageia (magically broke)";;
    "Magix")                OS="Magix (magically broke)";;
    "MagpieOS")             OS="MagpieOS (magpie-broke)";;
    "MainsailOS")           OS="MainsailOS (sailing into debt)";;
    "Mandriva")             OS="Mandriva (mandating my poverty)";;
    "Manjaro Linux")        OS="ManjarNO (Oh Please God No)";;
    "MassOS")               OS="MassOS (a massive amount of debt)";;
    "MatuuOS")              OS="MatuuOS (maturely broke)";;
    "Maui Linux")           OS="Maui (magical, but I'm not)";;
    "Mauna")                OS="Mauna (my money is mau-na)";;
    "meowix")               OS="meowix (it's purr-fectly broke)";;
    "Mer")                  OS="Mer (more broke every day)";;
    "MidnightBSD")          OS="MidnightBSD (the darkest of my financial moments)";;
    "Midos")                OS="Midos (my dos-sier of debt)";;
    "Minimal Linux")        OS="Minimal (like my salary)";;
    "MINIX")                OS="MINIX (mini-mal money)";;
    "Miracle Linux")        OS="Miracle (it would be a miracle if I had money)";;
    "Mos")                  OS="Mos (my OS is a moss of debt)";;
    "MSYS2")                OS="MSYS2 (my system is a mess)";;
    "MX Linux")             OS="MX Linux (eXtra broke)";;
    "Namib")                OS="Namib (namib-ly broke)";;
    "Nekos")                OS="Nekos (nya~nyo money)";;
    "Neptune")              OS="Neptune (a deep sea of debt)";;
    "NetBSD")               OS="NetBSD (fishing for money)";;
    "Netrunner")            OS="Netrunner (running on fumes)";;
    "Nexalinux")            OS="Nexalinux (the next line of my debt)";;
    "Nitrux")               OS="Nitrux (nitrous-ly broke)";;
    "NixOS")                OS="NixOS (broke and broken by design)";;
    "Nobara Linux")         OS="Nobara (Has 500 viruses from torrents)";;
    "NomadBSD")             OS="NomadBSD (a financial nomad)";;
    "Nu-OS")                OS="Nu-OS (nu-thing in my wallet)";;
    "Nurunner")             OS="Nurunner (running from my debt)";;
    "NuTyX")                OS="NuTyX (nutty about my lack of money)";;
    "Obarun")               OS="Obarun (I'm out-a-money)";;
    "ObRevenge")            OS="ObRevenge (revenge on my bank account)";;
    "OmniOS")               OS="OmniOS (omnipresent debt)";;
    "Opak")                 OS="Opak (opaque financial situation)";;
    "OpenBSD")              OS="OpenBSD (open to donations)";;
    "OpenEuler")            OS="OpenEuler (open-ly broke)";;
    "OpenIndiana")          OS="OpenIndiana (an open invitation to poverty)";;
    "OpenKylin")            OS="OpenKylin (a mythical creature, like my wealth)";;
    "OpenMamba")            OS="OpenMamba (mamba-broke)";;
    "OpenMandriva Lx")      OS="OpenMandriva (mandating my poverty)";;
    "OpenStage")            OS="OpenStage (putting my poverty on display)";;
    "openSUSE Leap")        OS="openSUSE Leap (into the void)";;
    "openSUSE MicroOS")     OS="openSUSE MicroOS (a micro amount of money)";;
    "openSUSE Slowroll")    OS="openSUSE Slowroll (slowly rolling into debt)";;
    "openSUSE Tumbleweed")  OS="openSUSE (tumbling into debt)";;
    "openSUSE")             OS="openSUSE (open-ly broke)";;
    "OpenWrt")              OS="OpenWrt (writing this from the street)";;
    "OPNsense")             OS="OPNsense (openly broke)";;
    "Oracle Linux")         OS="Oracle (all-knowing about my empty wallet)";;
    "Orchid")               OS="Orchid (an expensive flower, a broke person)";;
    "Oreon")                OS="Oreon (oh, re-on my debt)";;
    "OS Elbrus")            OS="OS Elbrus (I climbed a mountain of debt for this)";;
    "OSMC")                 OS="OSMC (Open Source Media Center, Open Source Money Cravings)";;
    "PacBSD")               OS="PacBSD (pac-ing my bags for poverty)";;
    "Panwah")               OS="Panwah (panicking with no money)";;
    "Parabola GNU/Linux-libre") OS="Parabola (a perfect curve of debt)";;
    "Parch Linux")          OS="Parch Linux (parched for cash)";;
    "Pardus")               OS="Pardus (partially broke)";;
    "Parrot OS")            OS="Parrot (squawking about my lack of cash)";;
    "Parsix")               OS="Parsix (my money is par-sixed)";;
    "PC-BSD")               OS="PC-BSD (paycheck-BSD)";;
    "PCLinuxOS")            OS="PCLinuxOS (penniless)";;
    "PearOS")               OS="PearOS (a pear of poverty)";;
    "Pengwin")              OS="Pengwin (a penguin, a broke one)";;
    "Pentoo")               OS="Pentoo (penniless, too)";;
    "Peppermint OS")        OS="Peppermint (peppering my bank account with nothing)";;
    "Peropesis")            OS="Peropesis (per-op-esis-ently broke)";;
    "PhyOS")                OS="PhyOS (financially broke)";;
    "PikaOS")               OS="PikaOS (shockingly broke)";;
    "Pisi Linux")           OS="Pisi Linux (my bank account's a mess)";;
    "PNM Linux")            OS="PNM Linux (pretty much broke)";;
    "Pop!_OS")              OS="Pop!_OS (But cant afford System76)";;
    "Porteus")              OS="Porteus (portending my debt)";;
    "PostmarketOS")         OS="PostmarketOS (after I sold my phone)";;
    "Proxmox Virtual Environment") OS="Proxmox (not a physical server, I'm broke)";;
    "PuffOS")               OS="PuffOS (puffing away my money)";;
    "Puppy Linux")          OS="Puppy (sad puppy eyes, no treats)";;
    "PureOS")               OS="PureOS (purely broke)";;
    "Q4OS")                 OS="Q4OS (quadruple-broke)";;
    "QTS")                  OS="QTS (quarterly taxed savings)";;
    "QUBES OS")             OS="QUBES OS (cubed debt)";;
    "Qubyt")                OS="Qubyt (a bit of a debt problem)";;
    "Quibian")              OS="Quibian (quick to go broke)";;
    "Quirinux")             OS="Quirinux (quirky broke)";;
    "Radix")                OS="Radix (the root of my debt)";;
    "Raspbian GNU/Linux")   OS="Raspbian (a raspberry pi for my tears)";;
    "RavynOS")              OS="RavynOS (like a raven, I have nothing to give)";;
    "RebornOS")             OS="RebornOS (reborn into debt)";;
    "Redcore Linux")        OS="Redcore (red with anger about my finances)";;
    "RedOS")                OS="RedOS (red ink in my bank account)";;
    "Red Star OS")          OS="Red Star OS (a star-studded debt)";;
    "Refracted Devuan")     OS="Refracted Devuan (a different view of my debt)";;
    "Regata OS")            OS="Regata OS (a regatta of debt)";;
    "Regolith")             OS="Regolith (a layer of debt)";;
    "Rhaymos")              OS="Rhaymos (I'm a rhyme-o-povert)";;
    "Red Hat Enterprise Linux") OS="RHEL (Red Hat Enterprise Loans)";;
    "Rhino")                OS="Rhino (a massive debt)";;
    "Rocky Linux")          OS="Rocky Linux (bouncing checks)";;
    "ROSA Desktop Fresh")   OS="ROSA (my financial life is not rosy)";;
    "Sabayon Linux")        OS="Sabayon (too sweet to be true)";;
    "Sabotage Linux")       OS="Sabotage (my own finances)";;
    "Sailfish OS")          OS="Sailfish OS (sailing into debt)";;
    "SalentOS")             OS="SalentOS (sailing into debt)";;
    "Salient OS")           OS="Salient (sailing into debt)";;
    "Salix OS")             OS="Salix (salivating for money)";;
    "SambaBox")             OS="SambaBox (a dance of debt)";;
    "Sasanqua")             OS="Sasanqua (a flower of debt)";;
    "Scientific Linux")     OS="Scientific Linux (scientifically broke)";;
    "SEMC")                 OS="SEMC (self-enforced money crunch)";;
    "Septor")               OS="Septor (septum-ly broke)";;
    "SereneOS")             OS="SereneOS (serenely broke)";;
    "Serpent OS")           OS="Serpent OS (a snake-sized wallet)";;
    "SharkLinux")           OS="SharkLinux (a shark-sized debt)";;
    "ShastraOS")            OS="ShastraOS (a scripture of debt)";;
    "Shebang")              OS="Shebang (the whole shebang of debt)";;
    "Siduction")            OS="Siduction (a seductive debt)";;
    "SkiffOS")              OS="SkiffOS (skimming the surface of debt)";;
    "Slackel")              OS="Slackel (lackin')";;
    "Slackware")            OS="Slackware (no updates, no rent)";;
    "SleeperOS")            OS="SleeperOS (sleeping on debt)";;
    "Slitaz")               OS="Slitaz (slipping into debt)";;
    "SmartOS")              OS="SmartOS (a smart choice, but I'm broke)";;
    "Snigdha OS")            OS="Snigdha OS (smoothly broke)";;
    "Soda")                 OS="Soda (soddenly broke)";;
    "Solaris")              OS="Solaris (the sun has set on my money)";;
    "Solus")                OS="Solus (solo, broke and alone)";;
    "Source Mage")          OS="Source Mage (magically out of money)";;
    "SparkyLinux")          OS="SparkyLinux (my wallet has a short circuit)";;
    "SpoinkOS")             OS="SpoinkOS (spoinking into debt)";;
    "Starry")               OS="Starry (starry-eyed with debt)";;
    "Star")                 OS="Star (a star of debt)";;
    "Steam Deck")           OS="Steam Deck (I sold my steam library to afford this)";;
    "SteamOS")              OS="SteamOS (steaming hot with debt)";;
    "Stock Linux")          OS="Stock Linux (my stock portfolio is in the red)";;
    "Sulin")                OS="Sulin (sulling about my poverty)";;
    "SummitOS")             OS="SummitOS (at the peak of my debt)";;
    "SUSE")                 OS="SUSE (suse-ptibly broke)";;
    "SwagArch")             OS="SwagArch (swag-less and broke)";;
    "T2")                   OS="T2 (T-2 much debt)";;
    "Tails")                OS="Tails (it's a coin flip whether I have money)";;
    "Tatra")                OS="Tatra (my financial situation is a mess)";;
    "teArch")               OS="teArch (tea without money)";;
    "TileOS")               OS="TileOS (tiled with debt)";;
    "TorizonCore")          OS="TorizonCore (a core of debt)";;
    "Trisquel GNU/Linux")   OS="Trisquel (three-times broke)";;
    "TrueNAS SCALE")        OS="TrueNAS (truly not rich)";;
    "TUXEDO OS")            OS="TUXEDO (wearing a tux, but with holes in my pocket)";;
    "Twister OS")           OS="Twister (twisted financial situation)";;
    "Ublinux")              OS="Ublinux (ubuntu-ly broke)";;
    "Ubuntu Budgie")        OS="Ubuntu Budgie (little bird, no food)";;
    "Ubuntu Cinnamon")      OS="Ubuntu Cinnamon (spicy debt)";;
    "Ubuntu GNOME")         OS="Ubuntu GNOME (just g-gnome it, my money's gone)";;
    "Ubuntu Kylin")         OS="Ubuntu Kylin (a mythical creature, like my wealth)";;
    "Ubuntu MATE")          OS="Ubuntu MATE (my broke mate)";;
    "Ubuntu Studio")        OS="Ubuntu Studio (studio apartment)";;
    "Ubuntu Sway")          OS="Ubuntu Sway (swaying into debt)";;
    "Ubuntu Touch")         OS="Ubuntu Touch (a touch of debt)";;
    "Ubuntu")               OS="Ubunstu (Activate Windows Survivor)";;
    "Ubuntu Unity")         OS="Ubuntu Unity (united in poverty)";;
    "Ultramarine Linux")    OS="Ultramarine (ultra-broke)";;
    "Unifi")                OS="Unifi (unifying my debt)";;
    "Univalent")            OS="Univalent (uni-valently broke)";;
    "Univention Corporate Server") OS="Univention (unanimously broke)";;
    "Unknown")              OS="Unknown (and unknowably broke)";;
    "UOS")                  OS="UOS (U owe money)";;
    "URUK OS")              OS="URUK OS (orcs have more gold than me)";;
    "Uwuntu")               OS="Uwuntu (UwU... I'm broke)";;
    "Valhalla")             OS="Valhalla (valhalla-tory broke)";;
    "Vanilla OS")           OS="Vanilla (a plain wallet)";;
    "Venom Linux")          OS="Venom (venomously broke)";;
    "VNUX")                 OS="VNUX (not a typo, just a mess)";;
    "Void Linux")           OS="Void (bank account matches the name)";;
    "vzLinux")              OS="vzLinux (virtually broke)";;
    "Wii Linux")            OS="Wii (we are all broke)";;
    "Windows 2025")         OS="Windows 2025 (still broke)";;
    "Windows 8")            OS="Windows 8 (still broke)";;
    "Windows 95")           OS="Windows 95 (I'm older than this debt)";;
    "Windows")              OS="Windows (Rebooting my patience)";;
    "WolfOS")               OS="WolfOS (a wolf of debt)";;
    "XCP-ng")               OS="XCP-ng (eX-tra broke)";;
    "Xenia")                OS="Xenia (a generous donation would be nice)";;
    "XeroArch")             OS="XeroArch (zero money, zero arch)";;
    "Xferience")            OS="Xferience (an experience of debt)";;
    "Xray OS")              OS="Xray OS (a clear view of my empty wallet)";;
    "Xubuntu")              OS="Xubuntu (Xtra broke)";;
    "YiffOS")               OS="YiffOS (yikes, I'm broke)";;
    "Zorin OS")             OS="Zorin (Because I cant afford Windows)";;
    "ZOS")                  OS="ZOS (zero out my bank account)";;
    *) OS="$OS_NAME (??)";;
esac


# Uptime - Linux, WSL & Android
if [ -r /proc/uptime ]; then
  UPTIME_S=$(cut -d ' ' -f1 < /proc/uptime)
  UPTIME_S=${UPTIME_S%.*}  # drop decimal part
  UPTIME_H=$(( UPTIME_S / 3600 ))
  UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
  UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
fi

# Uptime - macOS
if [ "$OS" = "macOS" ]; then
  BOOT_TIME=$(sysctl -n kern.boottime | awk -F'[ ,}]+' '{print $4}')
  NOW=$(date +%s)
  UPTIME_S=$((NOW - BOOT_TIME))
  UPTIME_H=$(( UPTIME_S / 3600 ))
  UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
  UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
fi

# Uptime - Windows
if [ "$OS_NAME" = "Windows" ]; then
  STATS=$(net stats srv 2>/dev/null | grep -i "Statistics since")
  if [ -n "$STATS" ]; then
    BOOT_TIME=$(echo "$STATS" | sed 's/.*since //')
    BOOT_TS=$(date -d "$BOOT_TIME" +%s 2>/dev/null)

    # Fallback
    if [ -z "$BOOT_TS" ]; then
      BOOT_TS=$(date -j -f "%m/%d/%Y %H:%M:%S" "$BOOT_TIME" +%s 2>/dev/null)
    fi

    if [ -n "$BOOT_TS" ]; then
      NOW=$(date +%s)
      UPTIME_S=$((NOW - BOOT_TS))
      UPTIME_H=$(( UPTIME_S / 3600 ))
      UPTIME_M=$(( (UPTIME_S % 3600) / 60 ))
      UPTIME="${UPTIME_H} hours, ${UPTIME_M} minutes"
    else
      UPTIME="The brokest"
    fi
  else
    UPTIME="Can't afford admin privilages"
  fi
fi

# RAM
MEMORY_MB=$RAM_MB

#CPU
cpu_rand=$(($RANDOM%6))
case $cpu_rand in
	0)CPU="Imaginary (thinking hard...)";;
	1)CPU="Hopes and dreams";;
	2)CPU="Two sticks rubbing together";;
	3)CPU="(Less powerful than) Atom";;
	4)CPU="Celery Acceleron";;
	5)CPU="Fentium";;
	6)CPU="Corei14billon (I wish)";;
esac

#GPU
if [ -f /etc/os-release ]; then
    # linux
    GPU_NAME="$(lspci | grep -Eio 'nvidia|intel|amd' | head -1)"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    GPU_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    GPU_NAME="Android"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            GPU_NAME="ARM"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            GPU_NAME="Windows"
            ;;
        *)
            GPU_NAME="IDK"
            ;;
    esac
fi
case "$GPU_NAME" in
    0)GPU="Integrated Depression";;
    Nvidia)GPU="Nvidia (but no drivers)";;
    AMD)
    if [ $((RANDOM % 2)) -eq 0 ]; then
        GPU="AMD (Ain't My Dollar)"
    else
        GPU="Radeon 7000 (from 2001)"
    fi
    ;;
    Intel)GPU="Inetl (I can't afford a real one)";;
    IDK)GPU="Voodoo 3Dfx (I wish)";;
    WSL)GPU="Emulated (Like my life)";;
    Android)GPU="Adreno (from 2010)";;
    ARM)GPU="SoC (Soldered forever)";;
    Windows)GPU="Please purchase and activate to detect.";;
    *)
	if [ $((RANDOM % 2)) -eq 0 ]; then
        GPU="Go outside for better grapchisc"
    else
	    GPU="Integrated depression"
    fi
	;;
esac

#HOSTNAME
host_rand=$(($RANDOM%6))
case $host_rand in
    0)HOST="Bedroom Floor (Carpet extra)";;
    1)HOST="Creaky Desk (Chair not included)";;
    2)HOST="Atari 2600 (with 128MB RAM)";;
    3)HOST="IBM 5100 (55 pounds and counting)";;
    4)HOST="iPhone -10";;
    5)HOST="Side Closet";;
    6)HOST="Thinkpad 700T (From 1992)";;
esac

#Desktop Environment
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    DESKTOP_ENV="TTY"
elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENV="$XDG_CURRENT_DESKTOP"
else
    DESKTOP_ENV="$(echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]')"
fi

#Macos and windows and phone
case "$OS_NAME" in
    "macOS")
        DESKTOP_ENV="Aqua (because I can't afford a real desktop)";;
    "Windows")
        DESKTOP_ENV="Windows Desktop (but no money for a real OS)";;
    "WSL")
        DESKTOP_ENV="WSL Desktop (because I can't afford a real Linux)";;
    "Android")
        DESKTOP_ENV="Android Desktop (because I can't afford a real phone)";;
esac        

case "$DESKTOP_ENV" in
    "gnome") DESKTOP_ENV="Gnome (but no extensions)";;
    "kde") DESKTOP_ENV="KDE (but no Plasma)";;
    "xfce") DESKTOP_ENV="XFCE (because I can't afford KDE)";;
    "lxde") DESKTOP_ENV="LXDE (Lightweight, like my wallet)";;
    "mate") DESKTOP_ENV="MATE (because I can't afford Cinnamon)";;
    "cinnamon") DESKTOP_ENV="Cinnamon (but no money for a real desktop)";;
    "Hyprland") DESKTOP_ENV="Hyprland (Yeah Hyprland is a DE lil bro)";;
    "TTY") DESKTOP_ENV="TTY (go touch grass bro)";;
    *) DESKTOP_ENV="Unknown DE (probably broke like me)";;
esac

# Window Managers
if [ -n "$XDG_CURRENT_WM" ]; then
    WINDOW_MANAGER="$XDG_CURRENT_WM"
else
    WINDOW_MANAGER="$(echo "$XDG_SESSION_TYPE" | tr '[:upper:]' '[:lower:]')"
fi

#Macos and windows and phone
case "$OS_NAME" in
    "macOS")
        WINDOW_MANAGER="Quartz Compositor";;
    "Windows")
        WINDOW_MANAGER="Desktop Window Manager (DWM)";;
    "WSL")
        WINDOW_MANAGER="WSL Window Manager";;
    "Android")
        WINDOW_MANAGER="Android Window Manager";;
esac

# --- Funny WM names ---
case "$WINDOW_MANAGER" in
    "Andoir Window Manager") WINDOW_MANAGER="Andoir Window Manager (Termux ig)";;
    "KWin"|"kwin"|"kwin_wayland") WINDOW_MANAGER="KWin (the KDE janitor)";;
    "Mutter"|"mutter") WINDOW_MANAGER="Mutter (the GNOME babysitter)";;
    "Sway"|"sway") WINDOW_MANAGER="Sway (i3 but woke)";;
    "i3") WINDOW_MANAGER="i3 (tiled like my bathroom)";;
    "Openbox"|"openbox") WINDOW_MANAGER="Openbox (because closed boxes cost money)";;
    "Fluxbox"|"fluxbox") WINDOW_MANAGER="Fluxbox (because stability is overrated)";;
    "XFWM4"|"xfwm4") WINDOW_MANAGER="XFWM4 (four times more broke)";;
    "Metacity"|"metacity") WINDOW_MANAGER="Metacity (meta broke)";;
    "IceWM"|"icewm") WINDOW_MANAGER="IceWM (cold and minimal, like my bank account)";;
    "FVWM"|"fvwm") WINDOW_MANAGER="FVWM (Feels Very Wallet Miserable)";;
    "awesome") WINDOW_MANAGER="awesome (self-proclaimed)";;
    "herbstluftwm") WINDOW_MANAGER="herbstluftwm (gesundheit)";;
    "wayfire") WINDOW_MANAGER="Wayfire (burning your GPU for fun)";;
    "Hyprland"|"hyprland") WINDOW_MANAGER="Hyprland (hyper broke)";;
    "Quartz Compositor") WINDOW_MANAGER="Quartz Compositor (shiny but overpriced)";;
    "Desktop Window Manager (DWM)") WINDOW_MANAGER="Desktop Window Manager (Windows’ least exciting acronym)";;
    "tty") WINDOW_MANAGER="tty (Idk what to say here tbh)";;
    "Wayland"|"wayland") WINDOW_MANAGER="Wayland (X11 is old and scary)";;
    "X11"|"x11") WINDOW_MANAGER="X11 (Wayland is good for toddlers)";;
    *) WINDOW_MANAGER="$WINDOW_MANAGER (probably broke like me)";;
esac

# --- COMMAND LINE OPTIONS ---
# Get options
while getopts ":hva:lc" option; do
   case $option in
      h) # display Help
         echo "Only the therapist can help you at this point."
         echo "Oh and btw the -v option displays the version of brokefetch EDGE."
         echo " -a lets you override ASCII art distro name"
         echo " -l lists all available ASCII arts"
         echo " -c enables colors in the output"
         exit;;
      v) # display Version
         echo "brokefetch EDGE version 1.8"
         echo "Make sure to star the repository on GitHub :)"
         exit;;
      a) # Set ASCII override to what the user typed
         ASCII_OVERRIDE="$OPTARG"
         DISTRO_TO_DISPLAY=$(get_ascii_filename "$ASCII_OVERRIDE")
         ;;
      l) # List available ASCII arts
         echo "Recognized Operating Systems:"
         echo "adelie linux -> adelielinux.txt, aeon -> aeon.txt, aeros -> aeros.txt, afterglow -> afterglow.txt, aix -> aix.txt, almalinux -> almalinux.txt, alpine linux -> alpinelinux.txt, alter -> alter.txt, alt linux -> altlinux.txt, amazon linux -> amazonlinux.txt, amazon -> amazon.txt, amogos -> amogos.txt, anarchy linux -> anarchylinux.txt, android -> android.txt, anduinos -> anduinos.txt, antergos -> antergos.txt, antiX -> antix.txt, anushos -> anushos.txt, aosc os/retro -> aoscos/retro.txt, aosc os -> aoscos.txt, aperture os -> apertureos.txt, apricity os -> apricityos.txt, arch linux -> arch.txt, archbox -> archbox.txt, archcraft -> archcraft.txt, archlabs -> archlabs.txt, archlabs.txt, archstrike -> archstrike.txt, arcolinux -> arcolinux.txt, arkane -> arkane.txt, armbian -> armbian.txt, arselinux -> arselinux.txt, artix linux -> artixlinux.txt, arya -> arya.txt, asahi linux -> asahilinux.txt, asteroidos -> asteroidos.txt, aster -> aster.txt, astos -> astos.txt, astra linux -> astralinux.txt, athenaos -> athenaos.txt, aurora -> aurora.txt, axos -> axos.txt, azos -> azos.txt, bedrock linux -> bedrocklinux.txt, biglinux -> biglinux.txt, bitrig -> bitrig.txt, blackarch -> blackarch.txt, black mesa -> blackmesa.txt, black panther os -> blackpantheros.txt, blag -> blag.txt, blankon -> blankon.txt, bluelight os -> bluelightos.txt, bodhi linux -> bodhilinux.txt, bonsai linux -> bonsailinux.txt, bredos -> bredos.txt, bsd -> bsd.txt, bunsenlabs -> bunsenlabs.txt, cachyos -> cachyos.txt, calculate linux -> calculatelinux.txt, calinixos -> calinixos.txt, carbs linux -> carblinux.txt, cbl-mariner -> cbl-mariner.txt, celos -> celos.txt, center os -> centeros.txt, centos linux -> centoslinux.txt, cereus -> cereus.txt, chakra -> chakra.txt, chaletos -> chaletos.txt, chapeau -> chapeau.txt, chimera linux -> chimeralinux.txt, chonkysealos -> chonkysealos.txt, chromium os -> chromiumos.txt, cleanjaro -> cleanjaro.txt, clear linux os -> clearlinuxos.txt, clearos -> clearos.txt, clover -> clover.txt, cobalt -> cobalt.txt, codex -> codex.txt, condres os -> condresos.txt, cosmic os -> cosmos.txt, crux -> crux.txt, crystal linux -> crystallinux.txt, cucumber os -> cucumberos.txt, cuerdos linux -> cuerdoslinux.txt, cutefishos -> cutefishos.txt, cuteos -> cuteos.txt, cyberos -> cyberos.txt, cycledream -> cycledream.txt, dahliaos -> dahliaos.txt, darkos -> darkos.txt, debian gnu/linux -> debian.txt, deepin -> deepin.txt, desa os -> desa os.txt, devuan gnu/linux -> devuan.txt, dietpi -> dietpi.txt, draco's -> draco's.txt, dragonfly bsd -> dragonflybsd.txt, drauger os -> draugeros.txt, droidian -> droidian.txt, elbrus -> elbrus.txt, elementary os -> elementaryos.txt, elive -> elive.txt, encryptos -> encryptos.txt, endeavouros -> endeavouros.txt, endless os -> endlessos.txt, enso -> enso.txt, eshanizedos -> eshanizedos.txt, eurolinux -> eurolinux.txt, evolutionos -> evolutionos.txt, eweos -> eweos.txt, exherbo -> exherbo.txt, exodia predator -> exodiapredator.txt, fastfetch -> fastfetch.txt, fedora coreos -> fedoracoreos.txt, fedora kinoite -> fedorakinoite.txt, fedora sericea -> fedorasericea.txt, fedora silverblue -> fedorasilverblue.txt, fedora linux -> fedora.txt, femboyos -> femboyos.txt, feren os -> ferenos.txt, filotimo -> filotimo.txt, finnix -> finnix.txt, floflis -> floflis.txt, freebsd -> freebsd.txt, freemint -> freemint.txt, frugalware -> frugalware.txt, funtoo linux -> funtoolinux.txt, furreto -> furreto.txt, galliumos -> galliumos.txt, garuda linux -> garudalinux.txt, gentoo -> gentoo.txt, ghostbsd -> ghostbsd.txt, ghostfreak -> ghostfreak.txt, glaucus -> glaucus.txt, gnewsense -> gnewsense.txt, gnome -> gnome.txt, gnu -> gnu.txt, gobolinux -> gobolinux.txt, golden dog linux -> goldendoglinux.txt, grapheneos -> grapheneos.txt, grombyang -> grombyang.txt, gnu guix -> gnuguix.txt, haiku -> haiku.txt, hamonikr -> hamonikr.txt, hardclanz -> hardclanz.txt, harmonyos -> harmonyos.txt, hash -> hash.txt, hce -> hce.txt, heliumos -> heliumos.txt, huayra gnu/linux -> huayragnu/linux.txt, hybrid -> hybrid.txt, hydrapwk -> hydrapwk.txt, hydroos -> hydroos.txt, hyperbola gnu/linux-libre -> hyperbolagnu/linux-libre.txt, hypros -> hypros.txt, iglunix -> iglunix.txt, instantos -> instantos.txt, interix -> interix.txt, irix -> irix.txt, ironclad -> ironclad.txt, itclinux -> itclinux.txt, januslinux -> januslinux.txt, kaisen linux -> kaisenlinux.txt, kali linux -> kalilinux.txt, kalpa desktop -> kalpadesktop.txt, kaos -> kaos.txt, kde linux -> kdelinux.txt, kde neon -> kdeneon.txt, kernelos -> kernelos.txt, kibojoe -> kibojoe.txt, kiss -> kiss.txt, kogaion -> kogaion.txt, korora -> korora.txt, krassos -> krassos.txt, kslinux -> kslinux.txt, kubuntu -> kubuntu.txt, kylin linux -> kylinlinux.txt, lainos -> lainos.txt, langitketujuh -> langitketujuh.txt, laxeros -> laxeros.txt, lede -> lede.txt, lfs -> lfs.txt, libreelec -> libreelec.txt, lilidog -> lilidog.txt, lingmo -> lingmo.txt, linsire -> linsire.txt, linux lite -> linuxlite.txt, linux mint -> linuxmint.txt, linux -> linux.txt, live raizo -> liveraizo.txt, lliurex -> lliurex.txt, lmde -> lmde.txt, locos -> locos.txt, lubuntu -> lubuntu.txt, lunar linux -> lunarlinux.txt, macos -> macos.txt, mageia -> mageia.txt, magix -> magix.txt, magix.txt, magpieos -> magpieos.txt, mainsailos -> mainsailos.txt, mandriva -> mandriva.txt, manjaro linux -> manjarolinux.txt, massos -> massos.txt, matuuos -> matuuos.txt, maui linux -> mauilinux.txt, mauna -> mauna.txt, meowix -> meowix.txt, mer -> mer.txt, midnightbsd -> midnightbsd.txt, midos -> midos.txt, minimal linux -> minimallinux.txt, minix -> minix.txt, miracle linux -> miraclelinux.txt, mos -> mos.txt, msys2 -> msys2.txt, mx linux -> mxlinux.txt, namib -> namib.txt, nekos -> nekos.txt, neptune -> neptune.txt, netbsd -> netbsd.txt, netrunner -> netrunner.txt, nexalinux -> nexalinux.txt, nitrux -> nitrux.txt, nixos -> nixos.txt, nobara linux -> nobaralinux.txt, nomadbsd -> nomadbsd.txt, nu-os -> nu-os.txt, nurunner -> nurunner.txt, nutyx -> nutyx.txt, obarun -> obarun.txt, obrevenge -> obrevenge.txt, omnios -> omnios.txt, opak -> opak.txt, openbsd -> openbsd.txt, openeuler -> openeuler.txt, openindiana -> openindiana.txt, openkylin -> openkylin.txt, openmamba -> openmamba.txt, openmandriva lx -> openmandrivalx.txt, openstage -> openstage.txt, opensuse leap -> opensuseleap.txt, opensuse microos -> opensusemicroos.txt, opensuse slowroll -> opensuseslowroll.txt, opensuse tumbleweed -> opensusetumbleweed.txt, opensuse -> opensuse.txt, openwrt -> openwrt.txt, opnsense -> opnsense.txt, oracle linux -> oraclelinux.txt, orchid -> orchid.txt, oreon -> oreon.txt, os elbrus -> oselbrus.txt, osmc -> osmc.txt, pacbsd -> pacbsd.txt, panwah -> panwah.txt, parabola gnu/linux-libre -> parabolagnu/linux-libre.txt, parch linux -> parchlinux.txt, pardus -> pardus.txt, parrot os -> parrotos.txt, parsix -> parsix.txt, pc-bsd -> pcbsd.txt, pclinuxos -> pclinuxos.txt, pearos -> pearos.txt, pengwin -> pengwin.txt, pentoo -> pentoo.txt, peppermint os -> peppermintos.txt, peropesis -> peropesis.txt, phyos -> phyos.txt, pikaos -> pikaos.txt, pisi linux -> pisilinux.txt, pnm linux -> pnmlinux.txt, pop!_os -> pop!_os.txt, porteus -> porteus.txt, postmarketos -> postmarketos.txt, proxmox virtual environment -> proxmoxvirtualenvironment.txt, puffos -> puffos.txt, puppy linux -> puppylinux.txt, pureos -> pureos.txt, q4os -> q4os.txt, qts -> qts.txt, qubes os -> qubesos.txt, qubyt -> qubyt.txt, quibian -> quibian.txt, quirinux -> quirinux.txt, radix -> radix.txt, raspbian gnu/linux -> raspbiangnu/linux.txt, ravynos -> ravynos.txt, rebornos -> rebornos.txt, redcore linux -> redcorelinux.txt, redos -> redos.txt, red star os -> redstaros.txt, refracted devuan -> refracteddevuan.txt, regata os -> regataos.txt, regolith -> regolith.txt, rhaymos -> rhaymos.txt, red hat enterprise linux -> rhel.txt, rhino -> rhino.txt, rocky linux -> rockylinux.txt, rosa desktop fresh -> rosadesktopfresh.txt, sabayon linux -> sabayonlinux.txt, sabotage linux -> sabotagelinux.txt, sailfish os -> sailfishos.txt, salentos -> salentos.txt, salient os -> salientos.txt, salix os -> salixos.txt, sambabox -> sambabox.txt, sasanqua -> sasanqua.txt, scientific linux -> scientificlinux.txt, semc -> semc.txt, septor -> septor.txt, sereneos -> sereneos.txt, serpent os -> serpentos.txt, sharklinux -> sharklinux.txt, shastraos -> shastraos.txt, shebang -> shebang.txt, siduction -> siduction.txt, skiffos -> skiffos.txt, slackel -> slackel.txt, slackware -> slackware.txt, sleeperos -> sleeperos.txt, slitaz -> slitaz.txt, smartos -> smartos.txt, snigdha os -> snigdhaos.txt, soda -> soda.txt, solaris -> solaris.txt, solus -> solus.txt, source mage -> sourcemage.txt, sparkylinux -> sparkylinux.txt, spoinkos -> spoinkos.txt, starry -> starry.txt, star -> star.txt, steam deck -> steamdeck.txt, steamos -> steamos.txt, stock linux -> stocklinux.txt, sulin -> sulin.txt, summitos -> summitos.txt, suse -> suse.txt, swagarch -> swagarch.txt, t2 -> t2.txt, tails -> tails.txt, tatra -> tatra.txt, tearch -> tearch.txt, tileos -> tileos.txt, torizoncore -> torizoncore.txt, trisquel gnu/linux -> trisquel.txt, truenas scale -> truenasscale.txt, tuxedo os -> tuxedoos.txt, twister os -> twisteros.txt, ublinux -> ublinux.txt, ubuntu budgie -> ubuntubudgie.txt, ubuntu cinnamon -> ubuntucinnamon.txt, ubuntu gnome -> ubuntugnome.txt, ubuntu kylin -> ubuntukylin.txt, ubuntu mate -> ubuntumate.txt, ubuntu studio -> ubuntustudio.txt, ubuntu sway -> ubuntusway.txt, ubuntu touch -> ubuntutouch.txt, ubuntu -> ubuntu.txt, ubuntu unity -> ubuntuunity.txt, ultramarine linux -> ultramarinelinux.txt, unifi -> unifi.txt, univalent -> univalent.txt, univention corporate server -> univentioncorporateserver.txt, unknown -> unknown.txt, uos -> uos.txt, uruk os -> urukos.txt, uwuntu -> uwuntu.txt, valhalla -> valhalla.txt, vanilla os -> vanillaos.txt, venom linux -> venomlinux.txt, vnux -> vnux.txt, void linux -> voidlinux.txt, vzlinux -> vzlinux.txt, wii linux -> wiilinux.txt, windows 2025 -> windows2025.txt, windows 8 -> windows8.txt, windows 8.1 -> windows8.1.txt, windows 95 -> windows95.txt, windows -> windows.txt, wolfos -> wolfos.txt, xcp-ng -> xcp-ng.txt, xenia -> xenia.txt, xeroarch -> xeroarch.txt, xferience -> xferience.txt, xray os -> xrayos.txt, xubuntu -> xubuntu.txt, yiffos -> yiffos.txt, zorin os -> zorinos.txt, zos -> zos.txt"
         exit;;
     c) # Enable colors
         COLOR_MODE=true
         ;;
     \?) # Invalid option
         echo "We don't type that here."
         exit;;
   esac
done

# If color mode is enabled, set the color variables
if [ "$COLOR_MODE" = true ]; then
    GREEN="\033[32m"
    RED="\033[31m"
    BLUE="\033[34m"
    CYAN="\033[36m"
    WHITE="\033[37m"
    YELLOW="\033[33m"
    PURPLE="\033[35m"
    BOLD="\033[1m"
    RESET="\033[0m"
fi

# Reset ASCII variables before assigning
unset ascii_art_lines

# --- ASCII ART SELECTION ---
# Determine which ASCII art to display based on override or detected OS
if [[ -n "$ASCII_OVERRIDE" ]]; then
    DISTRO_TO_DISPLAY=$(get_ascii_filename "$ASCII_OVERRIDE")
    if ! load_ascii "$DISTRO_TO_DISPLAY"; then
        # Fallback to a default if override file not found
        load_ascii "default" || true
    fi
else
    DISTRO_TO_DISPLAY=$(get_ascii_filename "$OS_NAME")
    if ! load_ascii "$DISTRO_TO_DISPLAY"; then
        # Load default ASCII if no specific file is found
        load_ascii "default" || true
    fi
fi

# Use default ASCII if no specific or default file exists
if [[ ${#ASCII_ART_LINES[@]} -eq 0 ]]; then
    ASCII_ART_LINES=('
    "           -'"
    "         .o+'"
    "        'ooo/"
    "       '+oooo:"
    "      '+oooooo:"
    "      -+oooooo+:"
    "    '/:-:++oooo+:"
    "   '/++++/+++++++:"
    "  '/++++++++++++++:"
    " '/+++o$2oooooooo$1oooo/'"
    "./$2ooosssso++osssssso$1+'"
    "$2        .oossssso-''''/ossssss+'"
    "      -osssssso.          :ssssssso."
    "     :osssssss/          osssso+++."
    "    /ossssssss/          +ssssooo/-"
    "   '/ossssso+/:-          -:/+osssso+-"
    "  '+sso+:-'               '.-/+oso:"	
    "'++:.                      '-/+/"
    ".'                          '/"
    " "
    " "
    ')
fi

# Set the desired spacing width for the ASCII art.
max_width=0
for line in "${ASCII_ART_LINES[@]}"; do
    line_length=$(echo "$line" | sed -E "s/\x1B\[[0-9;]*[mK]//g" | wc -c)
    if [[ $line_length -gt $max_width ]]; then
        max_width=$line_length
    fi
done
# Add a small buffer for spacing
max_width=$((max_width + 4))

# Value of the color
COLOR=${!COLOR_NAME}

# Combine the ASCII art with the system info using printf for alignment
info=(
    "${BOLD}OS:${RESET} ${OS}"
    "${BOLD}Host:${RESET} ${HOST}"
    "${BOLD}Kernel:${RESET} 0.00/hr"
    "${BOLD}Uptime:${RESET} ${UPTIME_OVERRIDE}"
    "${BOLD}Packages:${RESET} ${PKG_COUNT} (none legal)"
    "${BOLD}Shell:${RESET} brokeBash 0.01"
    "${BOLD}Resolution:${RESET} CRT 640x480"
    "${BOLD}DE:${RESET} ${DESKTOP_ENV}"
    "${BOLD}WM:${RESET} ${WINDOW_MANAGER}"
    "${BOLD}Terminal:${RESET} Terminal of Regret"
    "${BOLD}CPU:${RESET} ${CPU}"
    "${BOLD}GPU:${RESET} ${GPU}"
    "${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
)

# --- OUTPUT ---
# Loop through the combined output lines
num_ascii_lines=${#ASCII_ART_LINES[@]}
num_info_lines=${#info[@]}
max_lines=$((num_ascii_lines > num_info_lines ? num_ascii_lines : num_info_lines))

# Print the header line first
printf "${COLOR}%s${RESET}\n" "${ASCII_ART_LINES[0]}"
printf "${COLOR}%s${RESET}\n" "${ASCII_ART_LINES[1]}"

# Print the body
for ((i=2; i<max_lines; i++)); do
    ascii_line="${ASCII_ART_LINES[$i]:-}"
    info_line=""
    if (( i-2 < num_info_lines )); then
        info_line="${info[$((i-2))]}"
    fi
    printf "${COLOR}%-${max_width}s${RESET} %s\n" "$ascii_line" "$info_line"
done

echo
printf "${BOLD}BROKEFETCH 🥀 1.8${RESET}\n"

