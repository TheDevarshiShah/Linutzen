# Script Workflow

## Start

- Display a welcome message:  
  `"Welcome to Linutzen v1.0 for <OS_TYPE>"`.
- Display the main menu.

## User Input: Main Menu

User selects an option (0–4 or 9):
- **0**: Run the `initial` function.
- **1**: Run the `updates` function.
- **2**: Run the `apps` function.
- **3**: Run the `dev_tools` function.
- **4**: Run the `battery` function.
- **9**: Exit the script.

## Functions Logic

### `initial`
- This function performs initial **one-time** setup tasks based on the OS type.

#### Fedora:
1. **DNF Modifications:**
Add the following lines to `/etc/dnf/dnf.conf`:
   - `fastestmirror=True`
   - `max_parallel_downloads=5`

2. **Install Gnome Tweaks (rpm)**

#### Ubuntu:
1. **Setting up Flathub**
2. **Install Gnome Tweaks (deb)**

---

### `updates`
- This function handles system updates and Flatpak updates based on the OS type.
- Inform the user that a reboot is recommended.

#### Fedora: `dnf update` and `flatpak update`

#### Ubuntu: `apt update && apt upgrade` and `flatpak update`

---

### `apps`
- This function installs predefined applications based on the OS type.

#### Fedora:
- **Applications to Install with `flatpak install flathub <app-id>` :**
   - Brave Browser
   - Firefox
   - VSCodium
   - Meld
   - Thunderbird
   - LibreOffice
   - Zoom
   - FreeTube
   - VLC
   - Bottles
   - ExtensionManager
   - Flatseal

#### Ubuntu:
- **Applications to Install with `snap install <app-name>` :**
   - Brave Browser
   - Codium (Classic)
   - Thunderbird
   - LibreOffice
   - Dialect
   - FreeTube
   - VLC
   - GNOME Maps (deb)

---

### `dev_tools`
- Set up development tools based on the OS type:
  - Git
  - SSH
  - Conda
  - Docker

---

### `battery`
- Optimize battery life by:
  - Switch the flag `AutoEnable` to `false` in `/etc/bluetooth/main.conf`
- Install [Auto-CPUFrequency](https://github.com/AdnanHodzic/auto-cpufreq.git).
