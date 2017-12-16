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

arista = 'arista_veos'
junos_pfe = 'juniper/vqfx10k-pfe'
junos_re = 'juniper/vqfx10k-re'

Vagrant.configure(2) do |config|

  # ######################################
  # ###   Define namespace for boxes   ###
  # ######################################
  sp1 = "spine01"
  sp2 = "spine02"
  agg1 = "aggregation01"
  agg2 = "aggregation02"
  lf1_re = "leaf01_re"
  lf1_pfe = "leaf01_pfe"
  lf2_re = "leaf02_re"
  lf2_pfe = "leaf02_pfe"
  lf3_re = "leaf03_re"
  lf3_pfe = "leaf03_pfe"
  lf4_re = "leaf04_re"
  lf4_pfe = "leaf04_pfe"


  # ######################################
  # ###       router1 - build vm       ###
  # ######################################
  config.vm.define 'router1' do |router1|
    router1.vm.box = arista
    router1.vm.network "forwarded_port", guest: 80, host: 8101
    router1.vm.network 'private_network',
                       virtualbox__intnet: 'router1mlag01a',
                       ip: '169.254.1.11', auto_config: false
    router1.vm.network 'private_network',
                       virtualbox__intnet: 'router1mlag01b',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       router1 - provision      ###
   # ######################################
    router1.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname router1
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.101/24 secondary"
    SHELL
  end

  # ######################################
  # ###       router2 - build vm       ###
  # ######################################
  config.vm.define 'router2' do |router2|
    router2.vm.box = arista
    router2.vm.network "forwarded_port", guest: 80, host: 8102
    router2.vm.network 'private_network',
                       virtualbox__intnet: 'router2mlag01a',
                       ip: '169.254.1.11', auto_config: false
    router2.vm.network 'private_network',
                       virtualbox__intnet: 'router2mlag01b',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       router2 - provision      ###
   # ######################################
    router2.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname router2
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.102/24 secondary"
    SHELL
  end

  # ######################################
  # ###       spine01 - build vm       ###
  # ######################################
  config.vm.define sp1 do |spine01|
    spine01.vm.box = arista
    spine01.vm.network "forwarded_port", guest: 80, host: 8111
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'router1spine01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'router2spine01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01floor01',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01floor02',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01floor03',
                       ip: '169.254.1.11', auto_config: false
    spine01.vm.network 'private_network',
                       virtualbox__intnet: 'spine01floor04',
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
  # ###       mlag01b - build vm       ###
  # ######################################
  config.vm.define 'mlag01b' do |mlag01b|
    mlag01b.vm.box = arista
    mlag01b.vm.network "forwarded_port", guest: 80, host: 8112
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'router1mlag01b',
                       ip: '169.254.1.11', auto_config: false
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'router2mlag01b',
                       ip: '169.254.1.11', auto_config: false
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor01',
                       ip: '169.254.1.11', auto_config: false
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor02',
                       ip: '169.254.1.11', auto_config: false
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor03',
                       ip: '169.254.1.11', auto_config: false
    mlag01b.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor04',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       mlag01b - provision      ###
   # ######################################
    mlag01b.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname mlag01b
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.112/24 secondary"
    SHELL
  end

  # ###########################################
  # ### spine1_pfe: Packet Forwarding Engine ##
  # ###########################################
  config.vm.define junos_pfe do |leaf01_pfe|
      leaf01_pfe.ssh.insert_key = false
      leaf01_pfe.vm.box = junos_pfe

      # DO NOT REMOVE / NO VMtools installed
      leaf01_pfe.vm.synced_folder '.', '/vagrant', disabled: true
      leaf01_pfe.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_internal"
  end

  # ########################################
  # ### leaf01_pfe: Packet Routing Engine ##
  # ########################################
  config.vm.define junos_re do |leaf01|
  config.vm.boot_timeout = 240
      leaf01.vm.hostname = "leaf01"
      leaf01.vm.box = junos_re
      leaf01.ssh.insert_key = false

      # DO NOT REMOVE / NO VMtools installed
      leaf01.vm.synced_folder '.', '/vagrant', disabled: true

      # Management Ports
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_internal"
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "reserved-bridge"

      ## Dataplane ports
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine01_leaf01"
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "spine02_leaf01"
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan1"
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan2"
      leaf01.vm.network 'private_network', auto_config: false, nic_type: '82540EM', virtualbox__intnet: "leaf01_lan3"
  end

  # ######################################
  # ###       floor02 - build vm       ###
  # ######################################
  config.vm.define 'floor02' do |floor02|
    floor02.vm.box = arista
    floor02.vm.network "forwarded_port", guest: 80, host: 8122
    floor02.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01afloor02',
                       ip: '169.254.1.11', auto_config: false
    floor02.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor02',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       floor02 - provision      ###
   # ######################################
    floor02.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname floor02
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.122/24 secondary"
    SHELL
  end

  # ######################################
  # ###       floor03 - build vm       ###
  # ######################################
  config.vm.define 'floor03' do |floor03|
    floor03.vm.box = arista
    floor03.vm.network "forwarded_port", guest: 80, host: 8123
    floor03.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01afloor03',
                       ip: '169.254.1.11', auto_config: false
    floor03.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor03',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       floor03 - provision      ###
   # ######################################
    floor03.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname floor03
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.123/24 secondary"
    SHELL
  end

  # ######################################
  # ###       floor04 - build vm       ###
  # ######################################
  config.vm.define 'floor04' do |floor04|
    floor04.vm.box = arista
    floor04.vm.network "forwarded_port", guest: 80, host: 8124
    floor04.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01afloor04',
                       ip: '169.254.1.11', auto_config: false
    floor04.vm.network 'private_network',
                       virtualbox__intnet: 'mlag01bfloor04',
                       ip: '169.254.1.11', auto_config: false

   # ######################################
   # ###       floor04 - provision      ###
   # ######################################
    floor04.vm.provision 'shell', inline: <<-SHELL
      sleep 30
      FastCli -p 15 -c "configure
      hostname floor04
      username ansible privilege 15 secret ansible1
      management api http-commands
        protocol http
        no shut
      interface Management1
        ip address 192.168.56.124/24 secondary"
    SHELL
  end
end
