# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "evidenceprime/jessie64"
  config.vm.box_version = "8.2.1"

  config.vm.provision "shell", path: "vagrant.sh"
  # you can port forward like this, only running the daemon inside the vm
  #  and using a client (e.g. the web ui) from the host
  # but using the remote cli makes it easier to know we're really in the vm
  # so for now I'm disabling this
  # config.vm.network "forwarded_port", guest: 9091, host: 9091

  # this requires an image with vbox guest additions
  # # but it will actually mount a new folder, not just rsync the contents
  config.vm.synced_folder "shared", "/home/vagrant/shared"

end

