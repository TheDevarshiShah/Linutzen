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

**Application to Install with official way:**
  - Brave Browser

#### Fedora:
- **Applications to Install with `flatpak install flathub <app-id>` :**
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
- **Applications to Install with `snap install <app-name>`:**
   - Codium (Classic)
   - Thunderbird
   - LibreOffice
   - Dialect
   - FreeTube
   - VLC
- **Applications to Install with `apt install <app-name>`:**
   - Tor Browser
   - GNOME Maps
   - Syncthing
- **Applications to Install with `flatpak install <app-name>`:**
   - Bottles

---

### `dev_tools`
- Set up development tools based on the OS type:
  - Git
  - SSH
  - Conda
  - Docker

---

### `battery`
- Install [Auto-CPUFrequency](https://github.com/AdnanHodzic/auto-cpufreq.git).

---

## Extra:
```
sudo cp /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf /etc/NetworkManager/conf.d/default-wifi-powersave-on-original.conf

# change the value wifi.powersave = 3 to 2

sudo systemctl restart NetworkManager
```

```
sudo cp /etc/UPower/UPower.conf /etc/UPower/UPower-original.conf

# modify to 
IgnoreLid=true
```

```
sudo cp /etc/systemd/logind.conf /etc/systemd/logind-original.conf

# modify to 
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```
