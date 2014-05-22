# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # ###################################################
  #                 BASE BOX
  # ####################################################
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "jxc876/ubuntu-puppet"
  
  # The hostname the machine should have, will be set on boot
  config.vm.hostname = "vagrant"
  
  # A message to show after vagrant up
  # config.vm.post_up_message

  # ###################################################
  #                 FOWARDED PORTS
  # ####################################################
  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  
  # ###################################################
  #                 PRIVATE NETWORK
  # ####################################################
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"
  
  
  # ###################################################
  #                 PUBLIC NETWORK
  # ####################################################
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network
  
  
  # ###################################################
  #                 SHARED FOLDERS
  # ####################################################
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  
  # ###################################################
  #                 VIRTUAL BOX
  # ####################################################
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # This allows symlinks to be created within the /vagrant root directory, 
    # which is something librarian-puppet needs to be able to do. This might
    # be enabled by default depending on what version of VirtualBox is used.
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
	vb.name = "vagrant_vm"
	# vb.gui = true
	# vb.memory = "1024"
	# vb.cpus = "2"
  end
  

  # ###################################################
  #                PROVISION - SHELL
  # ####################################################
  # This shell provisioner installs librarian-puppet and runs it to install
  # puppet modules. This has to be done before the puppet provisioning so that
  # the modules are available when puppet tries to parse its manifests.
  config.vm.provision :shell, :path => "shell/main.sh"

  # ###################################################
  #                PROVISION - PUPPET
  # ####################################################
  # Now run the puppet provisioner. Note that the modules directory is entirely
  # managed by librarian-puppet
  # config.vm.provision :puppet do |puppet|
  #  puppet.manifests_path = "puppet/manifests"
  #  puppet.manifest_file  = "main.pp"
  # end

end
