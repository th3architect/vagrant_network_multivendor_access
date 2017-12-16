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
junos_pfe = 'junos_pfe'
junos_re = 'junos_re'

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


  # ######################################
  # ###       router1 - build vm       ###
  # ######################################
  # config.vm.define 'router1' do |router1|
  #   router1.vm.box = arista
  #   router1.vm.network "forwarded_port", guest: 80, host: 8101
  #   router1.vm.network 'private_network',
  #                      virtualbox__intnet: 'router1mlag01a',
  #                      ip: '169.254.1.11', auto_config: false
  #   router1.vm.network 'private_network',
  #                      virtualbox__intnet: 'router1mlag01b',
  #                      ip: '169.254.1.11', auto_config: false
  #
  #  # ######################################
  #  # ###       router1 - provision      ###
  #  # ######################################
  #   router1.vm.provision 'shell', inline: <<-SHELL
  #     sleep 30
  #     FastCli -p 15 -c "configure
  #     hostname router1
  #     username ansible privilege 15 secret ansible1
  #     management api http-commands
  #       protocol http
  #       no shut
  #     interface Management1
  #       ip address 192.168.56.101/24 secondary"
  #   SHELL
  # end

  # ######################################
  # ###       router2 - build vm       ###
  # ######################################
  # config.vm.define 'router2' do |router2|
  #   router2.vm.box = arista
  #   router2.vm.network "forwarded_port", guest: 80, host: 8102
  #   router2.vm.network 'private_network',
  #                      virtualbox__intnet: 'router2mlag01a',
  #                      ip: '169.254.1.11', auto_config: false
  #   router2.vm.network 'private_network',
  #                      virtualbox__intnet: 'router2mlag01b',
  #                      ip: '169.254.1.11', auto_config: false
  #
  #  # ######################################
  #  # ###       router2 - provision      ###
  #  # ######################################
  #   router2.vm.provision 'shell', inline: <<-SHELL
  #     sleep 30
  #     FastCli -p 15 -c "configure
  #     hostname router2
  #     username ansible privilege 15 secret ansible1
  #     management api http-commands
  #       protocol http
  #       no shut
  #     interface Management1
  #       ip address 192.168.56.102/24 secondary"
  #   SHELL
  # end

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

end
