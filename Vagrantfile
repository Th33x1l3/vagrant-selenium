VAGRANTFILE_API_VERSION = "2"
Vagrant.require_plugin "vagrant-reload"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# default ubuntu/xenial64 changed user from vagrant:vagrabt to ubuntu:<some pass nobody knows>
	# so we're using a external source that is doing a good job, at least by vagrant user community checks  
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network "private_network", ip: "192.168.50.4"
  
  
  puts "proxyconf..."
  if Vagrant.has_plugin?("vagrant-proxyconf")
    puts "find proxyconf plugin !"
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http     = ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https    = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  end
  
  config.vm.provision "shell", path: "script.sh"
  config.vm.provision :reload
  

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory=2048
  end
end
