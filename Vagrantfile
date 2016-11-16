VAGRANTFILE_API_VERSION = "2"

required_plugins = %w(vagrant-proxyconf vagrant-cachier vagrant-vbguest vagrant-reload)

plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# default ubuntu/xenial64 changed user from vagrant:vagrabt to ubuntu:<some pass nobody knows>
	# so we're using a external source that is doing a good job, at least by vagrant user community checks  
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.network :public_network, bridge: "enp4s0"
  config.vm.boot_timeout = 360

  
  
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

  #config.vm.define 'vagrant_selenium' 
   
  config.vm.provision "shell", path: "script.sh"
  


  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory=2048
    #vb.name = "vagrant_selenium"
  end
end
