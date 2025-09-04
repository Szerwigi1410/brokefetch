
#!/bin/bash
export LC_ALL=en_US.UTF-8

# IMPORTANT NOTE: This script is called "brokefetch_mod.sh" because it is modular which means it uses external sources to work.
# It is a work in progress.
# This script will display different ASCII for each OS from an external logos folders.

#!/bin/bash
CONFIG_FILE="$HOME/.config/brokefetch/config"
#i did this so they think twice before thet get flashbanged :> 
ASCII_DIR="/usr/share/brokefetch/logos/logos"
OS_LIST_FILE="$(dirname "$0")/os_list.txt"

# Create default config if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    printf "%s\n" "# Available COLOR_NAME options: RED, GREEN, BLUE, CYAN, WHITE" > "$CONFIG_FILE"
    printf "%s\n" "# Set RAM_MB to your desired memory size in MB" >> "$CONFIG_FILE"
    printf "%s\n" "# Set UPTIME_OVERRIDE to your desired uptime in hours" >> "$CONFIG_FILE"
    printf "%s\n" "RAM_MB=128" "UPTIME_OVERRIDE=16h" "COLOR_NAME=CYAN" >> "$CONFIG_FILE"
fi

# Load values from the config file
source "$CONFIG_FILE"

# Create logos directory if it doesn't exist
if [[ ! -d "$ASCII_DIR" ]]; then
   sudo mkdir -p "$ASCII_DIR"
fi

# Array to hold the ASCII art lines
declare -a ASCII_ART_LINES

# A flag to check if we should enable colors
COLOR_MODE=true

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
        # --- NEW ADDITION ---
        "aserdev") filename="aserdev" ;;
        *)
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
elif command -v brew &>/dev/null; then
    PKG_COUNT=$(brew list | tr -cd '\0-\177' | wc -l)
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
	"aserdev")			   OS="aserdev-os(bootleg arch? with non-offical repos.)";;
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
    "ChonkySealOS")        OS="ChonkyOS (chonky debt)";;
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
    "CutefishOS")           OS="CutefishOS (the debt is not cute)";;
    "CuteOS")               OS="CuteOS (the debt is not cute)";;
    "CyberOS")              OS="CyberOS (cyber-broke)";;
    "Cycledream")           OS="Cycledream (cycling through my debt)";;
    "dahliaOS")             OS="dahliaOS (blooming debt)";;
    "DarkOS")               OS="DarkOS (a dark financial situation)";;
    "Debian GNU/Linux")     OS="Plebian 12 (brokeworm)";;
    "Deepin")               OS="Deepin (deep in debt)";;
    "DesaOS")               OS="DesaOS (I desa-ved a better bank account)";;
    "Devuan GNU/Linux")     OS="Devuan (D-Debt, not SystemD)";;
    "DietPi")               OS="DietPi (on a strict budget)";;
    "Draco's")              OS="Draco's (dragon hoarding gold, but not for me)";;
    "DragonFly BSD")        OS="DragonFly (flying straight into debt)";;
    "Drauger OS")           OS="Drauger (an undead OS)";;
    "Droidian")             OS="Droidian (the droids you are looking for... but I'm looking for money)";;
    "Elbrus")               OS="Elbrus (I climbed a mountain of debt for this)";;
    "elementary OS")        OS="elementaryOS (baby's first macbook)";;
    "Elive")                OS="Elive (barely alive financially)";;
    "EncryptOS")            OS="EncryptOS (my money is encrypted with debt)";;
    "EndeavourOS")          OS="EndeavourOS (Arch for fetuses)";;
    "Endless OS")           OS="Endless (like my debt)";;
    "Enso")                 OS="Enso (the circle of life... and debt)";;
    "EshanizedOS")          OS="EshanizedOS (I'm a fan of this, but not my bank account)";;
    "EuroLinux")            OS="EuroLinux (euro-poverty)";;
    "EvolutionOS")          OS="EvolutionOS (evolving my debt)";;
    "EweOS")                OS="EweOS (ewww, my bank account)";;
    "Exherbo")              OS="Exherbo (too rare for my wallet)";;
    "Exodia Predator")      OS="Exodia Predator (my wallet's predator)";;
    "Fastfetch")            OS="Fastfetch (faster than my paycheck)";;
    "Fedora CoreOS")        OS="Fedora CoreOS (a core of debt)";;
    "Fedora Kinoite")       OS="Fedora Kinoite (a knight in debt)";;
    "Fedora Sericea")       OS="Fedora Sericea (seri-ously broke)";;
    "Fedora Silverblue")    OS="Fedora Silverblue (silver-less and broke)";;
    "Fedora Linux")         OS="Fedora (tips hat in poverty)";;
    "FemboyOS")             OS="FemboyOS (fiercely broke)";;
    "Feren OS")             OS="Feren OS (feren-tly broke)";;
    "Filotimo")             OS="Filotimo (a love of honor, not money)";;
    "Finnix")               OS="Finnix (fleeing my debt)";;
    "Floflis")              OS="Floflis (flow-of-money-is-not-happening)";;
    "FreeBSD")              OS="FreeBSD (Free software, broke user)";;
    "FreeMint")             OS="FreeMint (free, but I still can't afford it)";;
    "Frugalware")           OS="Frugalware (being frugal is my only choice)";;
    "Funtoo Linux")         OS="Funtoo (fun to use, not to pay for)";;
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

# Kernel
if [ -f /etc/os-release ]; then
    # linux
    KERNEL_NAME="$(uname -r | grep -Eio 'zen|lts|rt|realtime' | head -1)"
    case $KERNEL_NAME in
        zen)KERNEL="Zen (But no peace in life)";;
        lts)KERNEL="LTS (But no stability in life)";;
        rt)KERNEL="Realtime (But lagging in life)";;
        realtime)KERNEL="Realtime (But lagging in life)";;
        *)KERNEL="$ 0.00/hour"
    esac
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    KERNEL_NAME="Costs 129 dollars plus electricity."
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    KERNEL_NAME="Android (Fake Linux ripoff)"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        "Darwin")
            KERNEL="Darwin (Ate my wallet)"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            KERNEL="NT (Like a tricycle the price of a Porsche)"
            ;;
        *)
            KERNEL="Generic (Synonym: Your life)"
            ;;
    esac
fi


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
cpu_rand=$(($RANDOM%8))
case $cpu_rand in
	0)CPU="Imaginary (thinking hard...)";;
	1)CPU="Hopes and dreams";;
	2)CPU="Two sticks rubbing together";;
	3)CPU="(Less powerful than) Atom";;
	4)CPU="Celery Acceleron";;
	5)CPU="Fentium";;
	6)CPU="Corei14billon (I wish)";;
 	7)CPU="Open it and look";;
  	8)CPU="Could be Intel, maybe AMD";;
esac

#GPU
if [ -f /etc/os-release ]; then
    # linux
    GPU_NAME="$(lspci | grep -iE 'VGA' | awk -F ': ' '{print $2}' | awk '{print $1}' | tr '[:upper:]' '[:lower:]')"
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
    Nvidia | nvidia)GPU="Nvidia (but no drivers)";;
    AMD)
    if [ $((RANDOM % 2)) -eq 0 ]; then
        GPU="AMD (Ain't My Dollar)"
    else
        GPU="Radeon 7000 (from 2001)"
    fi
    ;;
    Intel | intel)GPU="Inetl (I can't afford a real one)";;
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
host_rand=$(($RANDOM%8))
case $host_rand in
    0)HOST="Bedroom Floor (Carpet extra)";;
    1)HOST="Creaky Desk (Chair not included)";;
    2)HOST="Atari 2600 (with 128MB RAM)";;
    3)HOST="IBM 5100 (55 pounds and counting)";;
    4)HOST="iPhone -10";;
    5)HOST="Side Closet";;
    6)HOST="Thinkpad 700T (From 1992)";;
	7)HOST="Library computer";;
 	8)HOST="Stolen laptop";;
esac

#Shell
if [ -f /etc/os-release ]; then
    # linux
    SHELL_NAME="$(echo $SHELL | grep -Ei "/bin" | awk -F "bin/" '{print $2}')"
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # windows subsystem for linux
    SHELL_NAME="WSL"
elif [[ "$(uname -o)" == "Android" ]]; then
    # Termux on Android
    SHELL_NAME="Termux"
else
    # Mac, Windows, Fallback (such as freeBSD)
    case "$(uname -s)" in
        Darwin)
            SHELL_NAME="$(echo $SHELL | grep -Ei "/bin" | awk -F "bin/" '{print $2}')"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            SHELL_NAME="pwsh"
            ;;
        *)
            SHELL_NAME="idksh"
            ;;
    esac
fi

case $SHELL_NAME in
    bash)SHELLOUT="$SHELL_NAME - The standard (for failure)";;
    zsh)SHELLOUT="$SHELL_NAME - Powerful (Unlike you)";;
    fish)SHELLOUT="$SHELL_NAME - Can't \"TAB to complete\" your life";;
#    tcsh)SHELLOUT="";;
#    csh)SHELLOUT="";;
    pwsh)SHELLOUT="$SHELL_NAME - Commands for noobs (on Windoze)";;
    sh)SHELLOUT="$SHELL_NAME - Old is gold (which I need)";;
    dash)SHELLOUT="$SHELL_NAME - Speeeeed (for debian only)";;
#    ksh)SHELLOUT="";;
    idksh)SHELLOUT="idksh - What is this? (YOUR future)";;
    *)SHELLOUT="Your shell is so niche that we don't care about it. We can't afford more code...";;
esac

#Desktop Environment
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    DESKTOP_ENV="TTY"
elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
    DESKTOP_ENV="$XDG_CURRENT_DESKTOP"
else
    DESKTOP_ENV="$(echo "$DESKTOP_SESSION" | tr '[:upper:]' '[:lower:]')"
fi
 
# Convert to lowercase for consistent matching in the next case statement
DESKTOP_ENV="$(echo "$DESKTOP_ENV" | tr '[:upper:]' '[:lower:]')"
 
#Macos and windows and phone
case "$OS_NAME" in
    "macOS")
        DESKTOP_ENV="aqua";;
    "Windows")
        DESKTOP_ENV="aero";;
    "WSL")
        DESKTOP_ENV="WSL";;
    "Android")
        DESKTOP_ENV="Android";;
esac
 
case "$DESKTOP_ENV" in
    "aqua") DESKTOP_ENV="Aqua (because I can't afford a real desktop)";;
    "aero") DESKTOP_ENV="Aero (but no money for a real DE)";;
    "Android") DESKTOP_ENV="Android Desktop (because I can't afford a real phone)";;
    "gnome") DESKTOP_ENV="Gnome (but no extensions)";;
    "kde" | "plasma") DESKTOP_ENV="KDE (but no Plasma)";;
    "xfce") DESKTOP_ENV="XFCE (Gnome ugly edition)";;
    "lxde") DESKTOP_ENV="LXDE (What's stopping you from LXqt?)";;
    "lxqt") DESKTOP_ENV="LXQt (Lightweight, like your wallet)";;
    "mate") DESKTOP_ENV="MATE (Gnome classic? What's that?)";;
    "x-cinnamon" | "cinnamon") DESKTOP_ENV="Cinnamon (but no money for a real desktop)";;
    "hyprland") DESKTOP_ENV="Hyprland (Yeah Hyprland is a DE lil bro)";;
    "WSL") DESKTOP_ENV="WSL Desktop (because I can't afford a real Linux)";;
    "tty") DESKTOP_ENV="TTY (go touch grass bro)";;
    "niri") DESKTOP_ENV="Niri (bro linux is not tiktok)";;
    "Budgie") DESKTOP_ENV="Budgie (but no budget)";;
    *) DESKTOP_ENV="${XDG_CURRENT_DESKTOP} (No funny name for you)";;
esac

# Window Managers

WINDOW_SYSTEM="$(echo "$XDG_SESSION_TYPE" | tr '[:upper:]' '[:lower:]')"

# --- Funny WM names ---
case "$DESKTOP_SESSION" in
    "kde" | "plasma") WINDOW_MANAGER="KWin (the KDE janitor)";;
    "Mutter"|"mutter" | "gnome") WINDOW_MANAGER="Mutter (the GNOME babysitter)";;
    "Sway"|"sway") WINDOW_MANAGER="Sway (i3 but woke)";;
    "i3") WINDOW_MANAGER="i3 (tiled like my bathroom)";;
    "Openbox"|"openbox") WINDOW_MANAGER="Openbox (because closed boxes cost money)";;
    "Fluxbox"|"fluxbox") WINDOW_MANAGER="Fluxbox (because stability is overrated)";;
    "XFCE"|"xfce") WINDOW_MANAGER="XFWM4 (four times more broke)";;
    "Metacity"|"metacity") WINDOW_MANAGER="Metacity (meta broke)";;
    "LXQt"|"lxqt") WINDOW_MANAGER="I don't know leave me alone";;
    "IceWM"|"icewm") WINDOW_MANAGER="IceWM (cold and minimal, like my bank account)";;
    "FVWM"|"fvwm") WINDOW_MANAGER="FVWM (Feels Very Wallet Miserable)";;
    "awesome") WINDOW_MANAGER="awesome (self-proclaimed)";;
    "herbstluftwm") WINDOW_MANAGER="herbstluftwm (gesundheit)";;
    "wayfire") WINDOW_MANAGER="Wayfire (burning your GPU for fun)";;
    "hyprland"|"Hyprland") WINDOW_MANAGER="Aquamarine (To drown myself in)";;
    "Quartz Compositor") WINDOW_MANAGER="Quartz Compositor (shiny but overpriced)";;
    "Desktop Window Manager (DWM)") WINDOW_MANAGER="Desktop Window Manager (Windows’ least exciting acronym)";;
    "tty") WINDOW_MANAGER="tty (Idk what to say here tbh)";;
    *) WINDOW_MANAGER="$WINDOW_MANAGER (probably broke like you)";;
esac

case "$OS_NAME" in
    "macOS")
        WINDOW_MANAGER="Quartz Compositor (shiny but overpriced)";;
    "Windows")
        WINDOW_MANAGER="Desktop Window Manager (Windows’ least exciting acronym)";;
    "WSL")
        WINDOW_MANAGER="WSL Window Manager (useless)";;
    "Android")
        WINDOW_MANAGER="Android Window Manager (Termux ig)";;
esac

# Window System
case "$WINDOW_SYSTEM" in
    "Wayland"|"wayland") WINDOW_SYSTEM="Wayland (X11 is old and scary)";;
    "X11"|"x11") WINDOW_SYSTEM="X11 (Wayland is good for toddlers)";;
    *) WINDOW_SYSTEM="${XDG_SESSION_TYPE} (probably broke like you)";;
esac

case "$OS_NAME" in
    "macOS")
        WINDOW_SYSTEM="Quartz or something idk";;
    "Windows")
        WINDOW_SYSTEM="Windows is your system";;
    "WSL")
        WINDOWS_SYSTEM="I don't know";;
    "Android")
        WINDOW_SYSTEM="Maybe wayland, maybe X11";;
esac

# Terminal
if [ -n "$TERM" ]; then
    TERMINAL="$TERM"
else
    TERMINAL="$(echo "$TERM" | tr '[:upper:]' '[:lower:]')"
fi

case "$TERM" in
    "xterm") TERMINAL="XTerm (the original terminal, but no money for a newer one)";;
    "xterm-color") TERMINAL="XTerm (but with a color)";;
    "xterm-256color") TERMINAL="XTerm (But with whole 256 colors!)";;
    "xterm-256colour") TERMINAL="XTerm (But with whole 256 colors and a U!)";;
    "gnome-terminal") TERMINAL="Gnome Terminal (because I dislike gnome console)";;
    "konsole") TERMINAL="Konsole (Can't spell ig)";;
    "terminator") TERMINAL="Terminator (you are NOT Arnold Schwarzenegger)";;
    "alacritty") TERMINAL="Alacritty (because I can't afford a real terminal)";;
    "xterm-kitty" | "kitty") TERMINAL="Kitty (Ur daddy's terminal)";;
    "rxvt-unicode") TERMINAL="Rxvt-Unicode (because I can't afford a real terminal)";;
    *) TERMINAL="Terminal of regret";;
esac


# --- COMMAND LINE OPTIONS ---
# Get options
while getopts ":hva:li:" option; do
   case $option in
      h) # display Help
         echo "Only the therapist can help you at this point."
         echo "Oh and btw the -v option displays the version of brokefetch EDGE."
         echo " -a lets you override ASCII art distro name"
         echo " -l lists all available ASCII arts"
         echo " -i <file> lets you use a custom ASCII file from anywhere on the system"
         echo " -c enables colors in the output"
         echo ""
         printf "%s\n" "The config file is currently located at ${BOLD}~/.config/brokefetch/${RESET}"
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
         echo "Available ASCII arts:"
         ls "$ASCII_DIR"
         exit;;
      i) # Set ASCII override to a specific file
         ASCII_OVERRIDE_FILE="$OPTARG"
         if [[ -f "$ASCII_OVERRIDE_FILE" ]]; then
             ASCII_FILE_PATH="$ASCII_OVERRIDE_FILE"
         else
             echo "Error: The specified ASCII art file could not be found."
             exit 1
         fi
         ;;
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
    GREEN=$'\033[32m'
    RED=$'\033[31m'
    BLUE=$'\033[34m'
    CYAN=$'\033[36m'
    WHITE=$'\033[37m'
    YELLOW=$'\033[33m'
    PURPLE=$'\033[35m'
    BOLD=$'\033[1m'
    RESET=$'\033[0m'
fi

# Reset ASCII variables before assigning
unset ascii_art_lines

# --- ASCII ART SELECTION ---
# Determine which ASCII art to display based on override or detected OS
if [[ -n "$ASCII_FILE_PATH" ]]; then
    # Use the user-specified file path directly
    mapfile -t ASCII_ART_LINES < "$ASCII_FILE_PATH"
elif [[ -n "$ASCII_OVERRIDE" ]]; then
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
	                       -`                     
	                      .o+`                    
	                     `ooo/                    
	                    `+oooo:                   
	                   `+oooooo:                  
	                   -+oooooo+:                 
	                 `/:-:++oooo+:               
	                `/++++/+++++++:               
	               `/++++++++++++++:              
	              `/+++ooooooooooooo/`            
	             ./ooosssso++osssssso+`           
	            .oossssso-````/ossssss+`          
	           -osssssso.      :ssssssso.         
	          :osssssss/        osssso+++.        
	         /ossssssss/        +ssssooo/-        
	       `/ossssso+/:-        -:/+osssso+-     
	      `+sso+:-`                 `.-/+oso:  
    	 `++:.                           `-/+/   
    	 .`                                 `/   
    	                                        
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
    "${COLOR}${BOLD}${RESET}$(whoami)@brokelaptop"
    "${COLOR}${RESET}-----------------------"
    "${COLOR}${BOLD}OS:${RESET} ${OS}"
    "${COLOR}${BOLD}Host:${RESET} ${HOST}"
    "${COLOR}${BOLD}Kernel:${RESET} ${KERNEL}"
    "${COLOR}${BOLD}Uptime:${RESET} ${UPTIME_OVERRIDE}"
    "${COLOR}${BOLD}Packages:${RESET} ${PKG_COUNT} (none legal)"
    "${COLOR}${BOLD}Shell:${RESET} ${SHELLOUT}"
    "${COLOR}${BOLD}Resolution:${RESET} CRT 640x480"
    "${COLOR}${BOLD}DE:${RESET} ${DESKTOP_ENV}"
    "${COLOR}${BOLD}WM:${RESET} ${WINDOW_MANAGER}"
    "${COLOR}${BOLD}Window system:${RESET} $WINDOW_SYSTEM"
    "${COLOR}${BOLD}Terminal:${RESET} ${TERMINAL}"
    "${COLOR}${BOLD}CPU:${RESET} ${CPU}"
    "${COLOR}${BOLD}GPU:${RESET} ${GPU}"
    "${COLOR}${BOLD}Memory:${RESET} ${MEMORY_MB}MB (user-defined-sadness)"
)

# --- OUTPUT ---
# Loop through the combined output lines
num_ascii_lines=${#ASCII_ART_LINES[@]}
num_info_lines=${#info[@]}
max_lines=$((num_ascii_lines > num_info_lines ? num_ascii_lines : num_info_lines))

# Print the header line first
printf "%b\n" "${COLOR}${ASCII_ART_LINES[0]}${RESET}"
printf "%b\n" "${COLOR}${ASCII_ART_LINES[1]}${RESET}"

# Print the body
for ((i=2; i<max_lines; i++)); do
    ascii_line="${ASCII_ART_LINES[$i]:-}"
    info_line=""
    if (( i-2 < num_info_lines )); then
        info_line="${info[$((i-2))]}"
    fi
    printf "%b\n" "${COLOR}$(printf "%-${max_width}s" "$ascii_line")${RESET} $info_line"
done

echo
printf "%b\n" "${BOLD}BROKEFETCH 🥀 1.8${RESET}"
