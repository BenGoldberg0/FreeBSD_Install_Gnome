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
sysrc gdm_enable="YES"
sysrc gnome_enable="YES"
sysrc linux_enable="YES"

# configure linprocfs for Linux compatibility
if ! mount | grep -q "^linprocfs"; then
    echo "linprocfs     /compat/linux/proc     linprocfs     rw     0     0" >> /etc/fstab
    mkdir -p /compat/linux/proc
    mount linprocfs /compat/linux/proc
fi

# add required kernel modules that should load at boot
cat >> /boot/loader.conf << EOF
cuse_load="YES"
linux64_load="YES"
EOF

# PolicyKit configuration for wheel group
mkdir -p /usr/local/etc/polkit-1/rules.d
cat > /usr/local/etc/polkit-1/rules.d/40-wheel.rules << EOF
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

echo "Installation complete! After reboot, GNOME will start automatically via GDM."
echo "Your system will reboot in 30 seconds..."

sleep 30

reboot
