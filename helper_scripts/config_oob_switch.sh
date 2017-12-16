#!/bin/bash

echo "#################################"
echo "   Running config_oob_switch.sh"
echo "#################################"
sudo su

# Config for OOB Switch
cat <<EOT > /etc/network/interfaces

# The primary network interface
auto eth0
  iface eth0 inet dhcp

EOT

echo "#################################"
echo "   Finished "
echo "#################################"
