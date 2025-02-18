#!/bin/sh

# Exit on error
set -e

# Check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check if running on FreeBSD
echo "Installing GNOME and other stuff"

# Update package repository
pkg update && pkg upgrade -y

# Install XOrg
pkg install -y xorg

# Install GNOME
pkg install -y gnome

# Enable required services in rc.conf
sysrc dbus_enable="YES"
sysrc hald_enable="YES"
sysrc gdm_enable="YES"

# Enable GNOME-related services
sysrc gnome_enable="YES"

# Configure procfs
if ! mount | grep -q "^procfs"; then
    echo "procfs         /proc           procfs  rw      0       0" >> /etc/fstab
    mount procfs /proc
fi

# Add required kernel modules to load at boot
echo 'linux_enable="YES"' >> /etc/rc.conf

cat >> /boot/loader.conf << EOF
cuse_load="YES"
linux_load="YES"
EOF

# Configure PolicyKit
mkdir -p /usr/local/etc/polkit-1/rules.d
cat > /usr/local/etc/polkit-1/rules.d/40-wheel.rules << EOF
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

# Configure .xinitrc for users who want to start GNOME manually
echo 'exec gnome-session' > /usr/local/etc/X11/xinit/xinitrc

echo "Installation complete! Please reboot but first read the following:"
echo "After reboot, GNOME will start automatically via GDM."
echo "Alternatively, you can start it manually with 'startx' after logging in but there is no point."
