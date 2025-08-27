# FreeBSD GNOME Desktop Installation Script

This script automates the installation of GNOME desktop environment on FreeBSD.

## Prerequisites

1. **Install FreeBSD** from the latest DVD1.iso file available on [freebsd.org](https://www.freebsd.org)
   - During installation, ensure your user is added to the `wheel` group for administrative access

2. **Initial System Setup** (as root or using su):
   ```sh
   # Update package manager
   pkg update && pkg upgrade -y
   
   # Install required tools
   pkg install -y sudo git
   ```

3. **Configure sudo** (optional):
   ```sh
   # As root, run:
   visudo
   # Uncomment the line: %wheel ALL=(ALL:ALL) ALL
   ```

## Installation

Login as your regular user (must be in wheel group), then run:

```sh
# Clone the repository
sudo git clone https://github.com/PokerPlayer2000/FreeBSD_Install_Gnome

# Navigate to the directory
cd FreeBSD_Install_Gnome

# Make the script executable
chmod +x main.sh

# Run the installation script
sudo ./main.sh
```

## What This Script Does

- Installs Xorg display server
- Installs GNOME desktop environment
- Configures required services (dbus, gdm, gnome)
- Sets up Linux compatibility layer
- Configures PolicyKit for wheel group access
- Automatically reboots after 30 seconds

## After Installation

- System will reboot automatically
- GDM (GNOME Display Manager) will start on boot
- Login with your user credentials
- GNOME desktop will load

## Requirements

- FreeBSD 13.0 or later (recommended)
- amd64 architecture
- At least 4GB RAM (8GB recommended for smooth experience)
- 10GB+ free disk space

## Troubleshooting

If GNOME doesn't start after reboot:
- Check if GDM is running: `sudo service gdm status`
- Review logs: `sudo journalctl -xe` or check `/var/log/Xorg.0.log`
- Ensure your user is in the `video` group: `sudo pw groupmod video -m yourusername`

Good luck! Hopefully this works for you.
