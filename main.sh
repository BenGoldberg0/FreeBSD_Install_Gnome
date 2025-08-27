#!/bin/sh

# exit if error
set -e

# check if running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Installing GNOME and other stuff"

# update
pkg update && pkg upgrade -y

# install Xorg
pkg install -y xorg

# install GNOME
pkg install -y gnome

# enable required services in rc.conf
sysrc dbus_enable="YES"
sysrc hald_enable="YES"
sysrc gdm_enable="YES"

# Enable GNOME-related services
sysrc gnome_enable="YES"

# configure procfs
if ! mount | grep -q "^procfs"; then
    echo "procfs         /proc           procfs  rw      0       0" >> /etc/fstab
    mount procfs /proc
fi

# add required kernel modules that should load at boot
echo 'linux_enable="YES"' >> /etc/rc.conf

cat >> /boot/loader.conf << EOF
cuse_load="YES"
linux_load="YES"
EOF

# PolicyKit
mkdir -p /usr/local/etc/polkit-1/rules.d
cat > /usr/local/etc/polkit-1/rules.d/40-wheel.rules << EOF
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

echo "Installation complete! After reboot, GNOME will start automatically via GDM. Your system will reboot in a little bit".

sleep 30

reboot
