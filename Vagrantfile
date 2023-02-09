MASTER_IP       = "192.168.56.170" 
NODE_01_IP      = "192.168.56.171" 
$script = <<-SCRIPT
cd /home/vagrant
if [ -x /home/vagrant/install.sh ]; then
  echo "file for installing starship exists"
else
  curl -sS https://starship.rs/install.sh | tee install.sh
  chmod +x install.sh
fi
sh install.sh -b /usr/local/bin/ --yes
if grep -q "starship init bash" /home/vagrant/.bashrc; then
  echo "entry 'starship init bash' already exists in user .bashrc"
else
  echo 'eval "$(starship init bash)"' >> /home/vagrant/.bashrc
fi
if [[ -d /home/vagrant/.config && -f /home/vagrant/.config/starship.toml ]]; then
  echo "file /home/vagrant/.config/starship.toml already exists"
else
  mkdir -p /home/vagrant/.config && cp /vagrant/starship.toml /home/vagrant/.config/starship.toml
fi
apt-get update
apt-get -y upgrade
SCRIPT
Vagrant.configure(2) do |config| 
  config.vm.box = "bento/ubuntu-20.04" 

  vms = [ 
    { :name => "master",  :ip => MASTER_IP,  :cpus => 2, :memory => 2048 }, 
    { :name => "node-01", :ip => NODE_01_IP, :cpus => 1, :memory => 2048 }, 
  ]
  
  vms.each do |option| 
    config.vm.define option[:name] do |box| 
      box.vm.hostname = option[:name] 
      box.vm.network :private_network, ip: option[:ip] 
      box.vm.provider "virtualbox" do |vb| 
        vb.cpus = option[:cpus] 
        vb.memory = option[:memory] 
      end
    end
  end
end

Vagrant.configure(2) do |config| 
  config.vm.provision "shell", inline: $script
end