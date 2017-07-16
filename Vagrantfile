# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #config.vm.box = "debian/stretch64"
  config.vm.box = "fedora/26-cloud-base"
  config.vm.box_version = "20170705"

  config.vm.provision "shell", path: "vagrant.sh"#, privileged: false
  #config.vm.synced_folder "shared/", "/home/vagrant/shared"

end
