# ubuntu_automatic_install
полностью автоматическая установка сервера ubuntu с нашим ПО
запрашиваются только сетевые настройки
в процесе установки netplan заменяется на ifupdown и введенные пользователем сетевые параметры переносятся в /etc/network/interfaces

oem.seed: /cdrom/preseed/oem.seed (legacy)
ubuntu-server.seed: /cdrom/preseed/ubuntu-server.seed (uefi)
ks.cfg: /cdrom/ks.cfg (uefi)
ks.preseed: /cdrom/ks/preseed (uefi)
grub.cfg: /boot/grub/grub.cfg (uefi)
