#!/bin/bash

echo "#################################"
echo "   Running config_oob_switch.sh"
echo "#################################"
sudo su

# Config for OOB Switch
cat <<EOT > /etc/network/interfaces
auto lo
  iface lo inet loopback
  address 10.2.1.1/32

# The primary network interface
auto eth0
  iface eth0 inet dhcp

auto swp1
  iface swp1
  address 10.2.1.1/32

auto swp2
  iface swp2
  address 10.2.1.1/32

auto swp3
  iface swp3
  address 10.4.1.1/24

EOT

echo "#################################"
echo "   Finished "
echo "#################################"
