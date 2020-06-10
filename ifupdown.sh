#!/bin/bash

#узнаем имя сетевого интерфейса
IFACE_NAME=$(ip -o link | grep 'link/ether' | grep -oE "^[[:digit:]]:[[:space:]]([[:alnum:]]+)" | cut -d" " -f 2)

# прописываем интерфейсы в /etc/network/interfaces
echo "auto lo
iface lo inet loopback
auto $IFACE_NAME
iface $IFACE_NAME inet static" >> /etc/network/interfaces

# получаем вывод сетевых параметров из /etc/netplan/*.yaml и отправляем вывод в переменные
IP_ADDR=$(cat /etc/netplan/*.yaml | grep addresses | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/[0-9]\{1,3\}')
GATE=$(cat /etc/netplan/*.yaml | grep gateway4 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
DNS=$(cat /etc/netplan/*.yaml | grep - | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')

#отправляем вывод переменных в /etc/network/interfaces. Если вывод пустой (например, если юзер не указал шлюз или dns), не отправляем в соответствующие строки ничего.
if [ -z "$IP_ADDR" ]; then
  :
else
  echo address $IP_ADDR >> /etc/network/interfaces
fi

if [ -z "$GATE" ]; then
  :
else
  echo gateway $GATE >> /etc/network/interfaces
fi

if [ -z "$DNS" ]; then
  :
else
  echo dns-nameservers $DNS >> /etc/network/interfaces
fi

# говорим grub не использовать netplan и обновляем grub
#sed '11c\GRUB_CMDLINE_LINUX="netcfg/do_not_use_netplan=true"' /etc/default/grub && update-grub

# удаляем конфигурационные файлы netplan
rm -rf /etc/netplan/*.yaml

# удаляем netplan
apt purge -y nplan netplan.io
