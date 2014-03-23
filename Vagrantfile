# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "puppetlabs-precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"

  config.vm.define :zookeeper do |zookeeper|
    zookeeper.vm.hostname = "zookeeper.damienpapworth.com"
    zookeeper.vm.network "private_network", ip: "192.168.10.10"

    zookeeper.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    end
  end

  # Install a specified version of Puppet
  config.vm.provision :shell do |s|
    s.path = "bin/install_puppet.sh"
    s.args = "3.4.1-1puppetlabs1"
  end

  # Enable provisioning with Puppet stand alone.
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.options = "--verbose --debug"
  end

end
