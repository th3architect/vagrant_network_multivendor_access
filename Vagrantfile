# -*- mode: ruby -*-
# vi: set ft=ruby :

# Aggregation MLAG Topology
#
#
#                           +---------------+         +---------------+
#                           | aggregation01 |         | aggregation02 |
#                           +---------------+         +---------------+
#                              |              \     /            |
#                              |                \ /              |
#                              |                / \              |
#                              |              /     \            |
#                           +---------------+         +---------------+
#                           |    spine01    |---------|    spine02    |
#                           +---------------+         +---------------+
#                           /  |      \       \      /        /  |  \
#                       /      |         \      / \       /      |     \
#                   /          |          / \         /\         |        \
#               /              |     /         \  /         \    |           \
#           /                  |/            /     \            \|              \
#       /                  /   |         /            \          |   \             \
#   /                 /        |     /                   \       |         \          \
#   +--------------+        +---------------+         +---------------+        +--------------+
#   |    leaf01    |        |    leaf02     |         |    leaf03     |        |    leaf04    |
#   +--------------+        +---------------+         +---------------+        +--------------+

arista = 'arista_vEOS_4_20'
junos_pfe = 'vqfx_pfe_15_1X53'
junos_re = 'vqfx_re_15_1X53'
cumulus = 'CumulusCommunity/cumulus-vx'

$script = <<-SCRIPT
if grep -q -i 'cumulus' /etc/lsb-release &> /dev/null; then
    echo "### RUNNING CUMULUS EXTRA CONFIG ###"
    source /etc/lsb-release
    if [[ $DISTRIB_RELEASE =~ ^2.* ]]; then
        echo "  INFO: Detected a 2.5.x Based Release"

        echo "  adding fake cl-acltool..."
        echo -e "#!/bin/bash\nexit 0" > /usr/bin/cl-acltool
        chmod 755 /usr/bin/cl-acltool

        echo "  adding fake cl-license..."
        echo -e "#!/bin/bash\nexit 0" > /usr/bin/cl-license
        chmod 755 /usr/bin/cl-license

        echo "  Disabling default remap on Cumulus VX..."
        mv -v /etc/init.d/rename_eth_swp /etc/init.d/rename_eth_swp.backup

        echo "### Rebooting to Apply Remap..."

    elif [[ $DISTRIB_RELEASE =~ ^3.* ]]; then
        echo "  INFO: Detected a 3.x Based Release"
        echo "### Disabling default remap on Cumulus VX..."
        mv -v /etc/hw_init.d/S10rename_eth_swp.sh /etc/S10rename_eth_swp.sh.backup &> /dev/null
        echo "### Disabling ZTP service..."
        systemctl stop ztp.service
        ztp -d 2>&1
        echo "### Resetting ZTP to work next boot..."
        ztp -R 2>&1
        echo "  INFO: Detected Cumulus Linux v$DISTRIB_RELEASE Release"
        if [[ $DISTRIB_RELEASE =~ ^3.[1-9].* ]]; then
            echo "### Fixing ONIE DHCP to avoid Vagrant Interface ###"
            echo "     Note: Installing from ONIE will undo these changes."
            mkdir /tmp/foo
            mount LABEL=ONIE-BOOT /tmp/foo
            sed -i 's/eth0/eth1/g' /tmp/foo/grub/grub.cfg
            sed -i 's/eth0/eth1/g' /tmp/foo/onie/grub/grub-extra.cfg
            umount /tmp/foo
        fi
        if [[ $DISTRIB_RELEASE =~ ^3.[2-9].* ]]; then
            if [[ $(grep "vagrant" /etc/netd.conf | wc -l ) == 0 ]]; then
                echo "### Giving Vagrant User Ability to Run NCLU Commands ###"
                sed -i 's/users_with_edit = root, cumulus/users_with_edit = root, cumulus, vagrant/g' /etc/netd.conf
                sed -i 's/users_with_show = root, cumulus/users_with_show = root, cumulus, vagrant/g' /etc/netd.conf
            fi
        fi

    fi
fi
echo "### DONE ###"
echo "### Rebooting Device to Apply Remap..."
nohup bash -c 'sleep 10; shutdown now -r "Rebooting to Remap Interfaces"' &
SCRIPT

Vagrant.configure(2) do |config|

  # ######################################
  # ###   Define namespace for boxes   ###
  # ######################################
  # sp1 = "spine01"
  # sp2 = "spine02"
  # agg1 = "aggregation01"
  # agg2 = "aggregation02"
  # leaf01_re = "leaf01_re"
  # leaf01_pfe = "leaf01_pfe"
  # leaf02_re = "leaf02_re"
  # leaf02_pfe = "leaf02_pfe"
  # leaf03_re = "leaf03_re"
  # leaf03_pfe = "leaf03_pfe"
  # leaf04_re = "leaf04_re"
  # leaf04_pfe = "leaf04_pfe"
  wbid = ENV['USER']
  offset = 0

  # ######################################
  # ###    aggregation01 - build vm    ###
  # ######################################
  config.vm.define "aggregation01" do |device|

    device.vm.hostname = "aggregation01"

    device.vm.box = "CumulusCommunity/cumulus-vx"
    device.vm.box_version = "3.4.3"
    device.vm.provider "virtualbox" do |v|
      v.name = "#{wbid}_aggregation01"
      v.customize ["modifyvm", :id, '--audiocontroller', 'AC97', '--audio', 'Null']
      v.memory = 768
    end
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder ".", "/vagrant", disabled: true



    # NETWORK INTERFACES
      # link for swp1 --> spine01
      device.vm.network "private_network", virtualbox__intnet: "#{wbid}_net54", auto_config: false , :mac => "a00000000061"

      # link for swp2 --> spine02
      device.vm.network "private_network", virtualbox__intnet: "#{wbid}_net42", auto_config: false , :mac => "443839000043"

      # link for swp3 --> tbd
      device.vm.network "private_network", virtualbox__intnet: "#{wbid}_net47", auto_config: false , :mac => "44383900004c"


    device.vm.provider "virtualbox" do |vbox|
      vbox.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc4', 'allow-all']
      vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end

    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(sudo grep -q 'mesg n' /root/.profile 2>/dev/null && sudo sed -i '/mesg n/d' /root/.profile  2>/dev/null) || true;", privileged: false


    # Run the Config specified in the Node Attributes
    device.vm.provision :shell , privileged: false, :inline => 'echo "$(whoami)" > /tmp/normal_user'
    device.vm.provision "ansible" do |ansible|
        ansible.playbook = "provisioning/playbook.yml"
    end


    # Install Rules for the interface re-map
    device.vm.provision :shell , :inline => <<-delete_udev_directory
    if [ -d "/etc/udev/rules.d/70-persistent-net.rules" ]; then
        rm -rfv /etc/udev/rules.d/70-persistent-net.rules &> /dev/null
    fi
    rm -rfv /etc/udev/rules.d/70-persistent-net.rules &> /dev/null
    delete_udev_directory

    device.vm.provision :shell , :inline => <<-udev_rule
    echo "  INFO: Adding UDEV Rule: a0:00:00:00:00:61 --> swp1"
    echo 'ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="a0:00:00:00:00:61", NAME="swp1", SUBSYSTEMS=="pci"' >> /etc/udev/rules.d/70-persistent-net.rules
    udev_rule
    device.vm.provision :shell , :inline => <<-udev_rule
    echo "  INFO: Adding UDEV Rule: 44:38:39:00:00:43 --> swp2"
    echo 'ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="44:38:39:00:00:43", NAME="swp2", SUBSYSTEMS=="pci"' >> /etc/udev/rules.d/70-persistent-net.rules
    udev_rule
    device.vm.provision :shell , :inline => <<-udev_rule
    echo "  INFO: Adding UDEV Rule: 44:38:39:00:00:4c --> swp3"
    echo 'ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="44:38:39:00:00:4c", NAME="swp3", SUBSYSTEMS=="pci"' >> /etc/udev/rules.d/70-persistent-net.rules
    udev_rule

    device.vm.provision :shell , :inline => <<-vagrant_interface_rule
    echo "  INFO: Adding UDEV Rule: Vagrant interface = eth0"
    echo 'ACTION=="add", SUBSYSTEM=="net", ATTR{ifindex}=="2", NAME="eth0", SUBSYSTEMS=="pci"' >> /etc/udev/rules.d/70-persistent-net.rules
    echo "#### UDEV Rules (/etc/udev/rules.d/70-persistent-net.rules) ####"
    cat /etc/udev/rules.d/70-persistent-net.rules
    vagrant_interface_rule

    # Run Any Platform Specific Code and Apply the interface Re-map
    device.vm.provision :shell , :inline => $script

  end


 # ######################################
 # ###    aggregation02 - build vm    ###
 # ######################################
 config.vm.define 'aggregation02' do |aggregation02|
   aggregation02.vm.box = cumulus
   aggregation02.vm.network "forwarded_port", guest: 80, host: 8101
   aggregation02.vm.network 'private_network',
                      virtualbox__intnet: 'aggregation02_spine01',
                      ip: '169.254.1.11', auto_config: false
   aggregation02.vm.network 'private_network',
                      virtualbox__intnet: 'aggregation02_spine02',
                      ip: '169.254.1.11', auto_config: false
  end

  # ######################################
  # ###       spine01 - build vm       ###
  # ######################################
  config.vm.define 'spine01' do |spine01|
    spine01.vm.box = arista
    spine01.vm.network "forwarded_port", guest: 80, host: 8111
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'aggregation01_spine01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'aggregation02_spine01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01_leaf01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01_leaf02',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01_leaf03',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01_leaf04',
                       ip: '169.254.1.11', auto_config: false

  # ######################################
  # ###       spine01 - provision      ###
  # ######################################
    spine01.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname spine01
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.111/24 secondary"
    SHELL
  end

  # ######################################
  # ###       spine02 - build vm       ###
  # ######################################
  config.vm.define 'spine02' do |spine02|
    spine02.vm.box = arista
    spine02.vm.network "forwarded_port", guest: 80, host: 8112
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'aggregation01_spine02',
                       ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'aggregation02_spine02',
                       ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'spine02_leaf01',
                       ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'spine02_leaf02',
                       ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'spine02_leaf03',
                       ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network',
                       virtualbox__intnet: 'spine02_leaf04',
                       ip: '169.254.1.11', auto_config: false

  # ######################################
  # ###       spine02 - provision      ###
  # ######################################
    spine02.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname spine02
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.112/24 secondary"
    SHELL
  end

  # ###########################################
  # ### leaf01_pfe: Packet Forwarding Engine ##
  # ###########################################
  config.vm.define 'leaf01_pfe' do |leaf01_pfe|
      leaf01_pfe.ssh.insert_key = false
      leaf01_pfe.vm.box = junos_pfe

      # DO NOT REMOVE / NO VMtools installed
      leaf01_pfe.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf01_pfe.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_internal"
  end

  # ########################################
  # ### leaf01_re: Packet Routing Engine  ##
  # ########################################
  config.vm.define 'leaf01_re' do |leaf01_re|
  config.vm.boot_timeout = 240
      leaf01_re.vm.hostname = "leaf01"
      leaf01_re.vm.box = junos_re
      leaf01_re.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      leaf01_re.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_internal"
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"

      ## Dataplane ports
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine01_leaf01"
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine02_leaf01"
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan1"
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan2"
      leaf01_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan3"
  end

  # ###########################################
  # ### leaf02_pfe: Packet Forwarding Engine ##
  # ###########################################
  config.vm.define 'leaf02_pfe' do |leaf02_pfe|
      leaf02_pfe.ssh.insert_key = false
      leaf02_pfe.vm.box = junos_pfe

      # DO NOT REMOVE / NO VMtools installed
      leaf02_pfe.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf02_pfe.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf02_internal"
  end

  # ########################################
  # ### leaf02_re: Packet Routing Engine  ##
  # ########################################
  config.vm.define 'leaf02_re' do |leaf02_re|
  config.vm.boot_timeout = 240
      leaf02_re.vm.hostname = "leaf02"
      leaf02_re.vm.box = junos_re
      leaf02_re.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      leaf02_re.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf02_internal"
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"

      ## Dataplane ports
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine01_leaf02"
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine02_leaf02"
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf02_lan1"
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf02_lan2"
      leaf02_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf02_lan3"
  end

  # ###########################################
  # ### leaf03_pfe: Packet Forwarding Engine ##
  # ###########################################
  config.vm.define 'leaf03_pfe' do |leaf03_pfe|
      leaf03_pfe.ssh.insert_key = false
      leaf03_pfe.vm.box = junos_pfe

      # DO NOT REMOVE / NO VMtools installed
      leaf03_pfe.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf03_pfe.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf03_internal"
  end

  # ########################################
  # ### leaf03_re: Packet Routing Engine  ##
  # ########################################
  config.vm.define 'leaf03_re' do |leaf03_re|
  config.vm.boot_timeout = 240
      leaf03_re.vm.hostname = "leaf03"
      leaf03_re.vm.box = junos_re
      leaf03_re.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      leaf03_re.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf03_internal"
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"

      ## Dataplane ports
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine01_leaf03"
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine02_leaf03"
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf03_lan1"
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf03_lan2"
      leaf03_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf03_lan3"
  end

  # ###########################################
  # ### leaf04_pfe: Packet Forwarding Engine ##
  # ###########################################
  config.vm.define 'leaf04_pfe' do |leaf04_pfe|
      leaf04_pfe.ssh.insert_key = false
      leaf04_pfe.vm.box = junos_pfe

      # DO NOT REMOVE / NO VMtools installed
      leaf04_pfe.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf04_pfe.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf04_internal"
  end

  # ########################################
  # ### leaf04_re: Packet Routing Engine  ##
  # ########################################
  config.vm.define 'leaf04_re' do |leaf04_re|
  config.vm.boot_timeout = 240
      leaf04_re.vm.hostname = "leaf04"
      leaf04_re.vm.box = junos_re
      leaf04_re.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      leaf04_re.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf04_internal"
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"

      ## Dataplane ports
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine01_leaf04"
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine02_leaf04"
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf04_lan1"
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf04_lan2"
      leaf04_re.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf04_lan3"
  end

  ##############################
  ## Box provisioning        ###
  ## exclude Windows host    ###
  ##############################
  # if !Vagrant::Util::Platform.windows?
  #     config.vm.provision "ansible" do |ansible|
  #         ansible.groups = {
  #             "aggregation" => ["aggregation0[1:2]"],
  #             "spine" => ["spine0[1:2]"],
  #             "leaf_re" => ["leaf0[1:4]_re"],
  #             "leaf_pfe" => ["leaf0[1:4]_pfe"],
  #             "arista:children" => ["spine"],
  #             "juniper:children" => ["leaf_re", "leaf_pfe"],
  #             "cumulus:children" => ["aggregation"],
  #             "all:children" => ["arista", "cumulus", "juniper"]
  #         }
  #         ansible.playbook = "provisioning/playbook.yml"
  # end
  # end

end
