# -*- mode: ruby -*-
# vi: set ft=ruby :

# Spine-Leaf Architecture in a Multi-vendor Campus Access layer
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
junos_pfe = 'juniper/vqfx10k-pfe'
junos_re = 'juniper/vqfx10k-re'
cumulus = 'CumulusCommunity/cumulus-vx'

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
    device.vm.box = cumulus
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
      device.vm.network "private_network", virtualbox__intnet: "aggregation01_spine01", auto_config: false , :mac => "a00000000161"
      # link for swp2 --> spine02
      device.vm.network "private_network", virtualbox__intnet: "aggregation01_spine02", auto_config: false , :mac => "443839000143"
      # link for swp3 --> tbd
      device.vm.network "private_network", virtualbox__intnet: "aggregation01_aggregation02", auto_config: false , :mac => "44383900014c"
    device.vm.provider "virtualbox" do |vbox|
      vbox.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc4', 'allow-all']
      vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(sudo grep -q 'mesg n' /root/.profile 2>/dev/null && sudo sed -i '/mesg n/d' /root/.profile  2>/dev/null) || true;", privileged: false
  end


  # ######################################
  # ###    aggregation02 - build vm    ###
  # ######################################
  config.vm.define "aggregation02" do |device|
    device.vm.hostname = "aggregation02"
    device.vm.box = cumulus
    device.vm.box_version = "3.4.3"
    device.vm.provider "virtualbox" do |v|
      v.name = "#{wbid}_aggregation02"
      v.customize ["modifyvm", :id, '--audiocontroller', 'AC97', '--audio', 'Null']
      v.memory = 768
    end
    #   see note here: https://github.com/pradels/vagrant-libvirt#synced-folders
    device.vm.synced_folder ".", "/vagrant", disabled: true
    # NETWORK INTERFACES
      # link for swp1 --> spine01
      device.vm.network "private_network", virtualbox__intnet: "aggregation02_spine01", auto_config: false , :mac => "443839000201"
      # link for swp2 --> spine02
      device.vm.network "private_network", virtualbox__intnet: "aggregation02_spine02", auto_config: false , :mac => "443839000202"
      # link for swp3 --> tbd
      device.vm.network "private_network", virtualbox__intnet: "aggregation01_aggregation02", auto_config: false , :mac => "443839000203"
    device.vm.provider "virtualbox" do |vbox|
      vbox.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc3', 'allow-all']
      vbox.customize ['modifyvm', :id, '--nicpromisc4', 'allow-all']
      vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    # Fixes "stdin: is not a tty" and "mesg: ttyname failed : Inappropriate ioctl for device"  messages --> https://github.com/mitchellh/vagrant/issues/1673
    device.vm.provision :shell , inline: "(sudo grep -q 'mesg n' /root/.profile 2>/dev/null && sudo sed -i '/mesg n/d' /root/.profile  2>/dev/null) || true;", privileged: false
  end

  # ######################################
  # ###       spine01 - build vm       ###
  # ######################################
  config.vm.define 'spine01' do |spine01|
    spine01.vm.box = arista
    spine01.vm.network "forwarded_port", guest: 80, host: 8111
    spine01.vm.network 'private_network', virtualbox__intnet: 'aggregation01_spine01', ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network', virtualbox__intnet: 'aggregation02_spine01', ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network', virtualbox__intnet: 'spine01_leaf01', ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network', virtualbox__intnet: 'spine01_leaf02', ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network', virtualbox__intnet: 'spine01_leaf03', ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network', virtualbox__intnet: 'spine01_leaf04', ip: '169.254.1.11', auto_config: false

  end

  # ######################################
  # ###       spine02 - build vm       ###
  # ######################################
  config.vm.define 'spine02' do |spine02|
    spine02.vm.box = arista
    spine02.vm.network "forwarded_port", guest: 80, host: 8112
    spine02.vm.network 'private_network', virtualbox__intnet: 'aggregation01_spine02', ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network', virtualbox__intnet: 'aggregation02_spine02', ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network', virtualbox__intnet: 'spine02_leaf01', ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network', virtualbox__intnet: 'spine02_leaf02', ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network', virtualbox__intnet: 'spine02_leaf03', ip: '169.254.1.11', auto_config: false
    spine02.vm.network 'private_network', virtualbox__intnet: 'spine02_leaf04', ip: '169.254.1.11', auto_config: false

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
      leaf01_re.vm.network "forwarded_port", guest: 830, host: 8830
      leaf01_re.vm.network "forwarded_port", guest: 8080, host: 18080

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

  # ######################################
  # ###      topology - provision      ###
  # ######################################
  config.vm.provision "ansible" do |ansible|
      ansible.groups = {
          "aggregation" => ["aggregation0[1:2]"],
          "spine" => ["spine0[1:2]"],
          # "leaf" => ["leaf0[1:4]_re"],
          "arista:children" => ["spine"],
          # "juniper:children" => ["leaf"],
          "cumulus:children" => ["aggregation"],
          "all:children" => ["arista", "cumulus"]
      }
      # ansible.verbose = "vvvv"
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "provisioning/all.yml"
  end

end
