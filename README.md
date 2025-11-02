# BROKE*fetch*

![AUR License](https://img.shields.io/aur/license/brokefetch-git)
![GitHub top language](https://img.shields.io/github/languages/top/Szerwigi1410/brokefetch)
![Static Badge](https://img.shields.io/badge/made_with-vscode%2C_nano%2C_Xcode%2C_helix-blue)
[![AUR package](https://repology.org/badge/version-for-repo/aur/brokefetch.svg)](https://repology.org/project/brokefetch/versions)
[![AUR package](https://repology.org/badge/version-for-repo/aur/brokefetch-mod.svg)](https://repology.org/project/brokefetch-mod/versions)
![Linux](https://img.shields.io/badge/-Linux-grey?logo=linux)

A broken `neofetch` clone for those of us who have no job, no GPU, no money, and no hope.

![screenshot](screenshots/brokefetch-logo_att4.png)

![Brokefetch_logos](screenshots/forthegif/gif_for_readme.gif)

Version 1.0 screenshot

![screenshot](screenshots/screenshot.png)

## What is this?

`brokefetch` is the only system info tool that doesn't pretend your life is okay.

Inspired by `neofetch`, but with:
- Sadness
- Regret
- A CRT monitor

## Installation

```bash
git clone https://github.com/Szerwigi1410/brokefetch
cd brokefetch
chmod +x brokefetch.sh
./brokefetch.sh
```
### using install.sh
```bash
git clone https://github.com/Szerwigi1410/brokefetch
cd brokefetch
chmod +x install.sh
./install.sh
```
### or use the installer "OS-wide"

```bash
curl -sSL https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/install.sh > install.sh ; chmod +x install.sh ; bash -c "./install.sh" ; rm -f install.sh
```
### OS-wide for FreeBSD users

```bash
sudo curl -sSL https://raw.githubusercontent.com/Szerwigi1410/brokefetch/refs/heads/main/install_UI.sh > install_UI.sh ; sudo chmod +x install_UI.sh ; sudo bash -c "bash install_UI.sh" ; sudo rm -f install_UI.sh
```

### AUR (yes it's back)
```bash
yay -S brokefetch-git
```

### ~AUR mod~ not any more 😭

```bash
yay -S brokefetch-mod
```

### pacman

install aserdev's repo

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aserdevyt/aserdev-repo/refs/heads/main/install.sh)
```

install brokefetch

```bash
sudo pacman -Sy brokefetch
```

### Homebrew
```bash
brew tap T1mohtml/brokefetch
brew install brokefetch
```

### Nix Flake
```flake.nix```
```
{
  ...
  inputs = {
    # rest of the inputs

    brokefetch.url = "github:Szerwigi1410/brokefetch";    
  };

  outputs =
    {
      # other outputs
      ...
    }@inputs:
    {
      # implement modules here
    }
}
```

```configuration.nix```
```
{
  # rest of inputs (eg: pkgs, config, lib)
  inputs,
  ...
}

{
  # your configuration

  environment.systemPackages = with pkgs; [
    # rest of the packages
    inputs.brokefetch.packages.x86_64-linux.brokefetch # or replace brokefetch package with brokefetch-beta
  ];

  # rest of configuration
}
```
---
# Important note!

- `brokefetch.sh` - Stable, "just works"
- `brokefetch_beta.sh` - Might contain bugs, has the newest features
- `brokefetch_beta2.sh` - just a backup
- `brokefetch_EDGE_legacy.sh` - just a backup of the old edge version (currently not present)
- `brokefetch_mod.sh` - a version of EDGE that loads the logos from ~/.config/brokefetch/logos (mod stands for **mod**ular). Currently supports 485 ascii logos!

(brokefetch_EDGE got renamed to brokefetch_beta)

---
# Troubleshooting
If you have any issues with brokefetch, try to remove the config and run brokefetch again.

---

### 💖 If you enjoy brokefetch, please ⭐ it here and vote on the [AUR package](https://aur.archlinux.org/packages/brokefetch-git) to support its survival!

### ~Sadly we lost and some cock sucke- uhh I meant AUR trusted user has removed the package from AUR.~

### yay `brokefetch is back on the aur 🥳` ###

### give it a try

```bash
yay -S brokefetch-git
```
[![Packaging status](https://repology.org/badge/vertical-allrepos/brokefetch.svg)](https://repology.org/project/brokefetch/versions)
![AUR Last Modified](https://img.shields.io/aur/last-modified/brokefetch-git)

