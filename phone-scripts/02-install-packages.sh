#!/bin/bash
set -e

echo "==================="
echo "02-install-packages.sh"
echo "==================="

# Functions
infecho () {
    echo "[Info] $1"
}
errecho () {
    echo "[Error] $1" 1>&2
    exit 1
}

infecho "This adds the njha/mobile COPR repository and installs phone related packages."

infecho "Link temp-resolv.conf"
ln -sfv /etc/tmp-resolv.conf /etc/resolv.conf

infecho "Enabling COPR repository..."
dnf -q -y copr enable njha/mobile

infecho "Removing old kernel..."
infecho "THIS MIGHT FAIL, DON'T WORRY ITS PROBABLY OK"
dnf -q -y remove kernel || rpm -e --noscripts kernel-core
dnf -q -y install linux-firmware

infecho "Installing recommended packages..."
dnf -q -y install megi-kernel feedbackd phoc phosh squeekboard gnome-shell ModemManager rtl8723cs-firmware \
    dbus-x11 chatty calls carbons purple-mm-sms pinephone-helpers evolution-data-server \
    f35-backgrounds-gnome epiphany gnome-contacts NetworkManager-wwan \
    nautilus gvfs-goa megapixels gnome-power-manager gnome-usage xdg-user-dirs pipewire-alsa \
    pipewire-pulseaudio pp-uboot wlr-randr gnome-terminal gnome-clocks wireplumber

infecho "Enabling graphical boot and Phosh..."
systemctl disable initial-setup.service
systemctl disable gdm
systemctl enable phosh
systemctl set-default graphical.target

infecho "Making COPR higher priority for kernel updates..."
echo "priority=10" >> /etc/yum.repos.d/_copr\:copr.fedorainfracloud.org\:njha\:mobile.repo

infecho "Upgrading packages..."
dnf -q -y upgrade
