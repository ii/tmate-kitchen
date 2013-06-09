# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'berkshelf/vagrant'

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true
  config.vm.box = "ubuntu-12.04-server-amd64"

  config.ssh.forward_agent = true

  config.vm.define :tmate do |box|
    box.vm.provider(:virtualbox) do |vb|
      vb.name = box.vm.hostname = 'tmate'
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end
    box.vm.network :private_network, ip: "10.1.1.11"
    box.vm.network :forwarded_port, guest: 8000, host: 8000 # Graphite
    box.vm.network :forwarded_port, guest: 2200, host: 2200 # Tmate

    box.vm.provision :chef_solo do |chef|
      chef.roles_path = "roles"
      chef.run_list = [
        "recipe[root_ssh_agent::ppid]",
        "recipe[hosts]",
        "recipe[base]",
        "recipe[time]",
        "recipe[ruby]",
        "role[graphite]",
        "role[collectd_graphite]",
        "recipe[tmate_nginx]",
        "recipe[tmate]",
      ]
      chef.json = {
        hosts: {
          'monitor' => '10.1.1.11',
        },

        tmate:    { listen_port: 2200 },
        apache:   { listen_ports: [8000] },
        graphite: { listen_port: 8000, storage_schemas: [{ name: 'catchall', pattern: '^.*', retentions: '10s:3d' }] },
      }
    end
  end
end
