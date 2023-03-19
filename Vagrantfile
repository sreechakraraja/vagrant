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
if [ -x /usr/bin/tmux ]; then
  echo "tmux is already installed"
else
  echo "Installing tmux"
  apt-get install tmux
  if [-x /usr/bin/tmux ]; then
    echo "tmux is installed"
  else
    echo "failed to install tmux"
  fi
fi
apt-get -y upgrade
SCRIPT
Vagrant.configure(2) do |config| 
  # config.vm.box = "boxomatic/debian-11" # Debian 11 box 
  config.vm.box = "bento/ubuntu-20.04" 
  # config.vm.provider :virtualbox do |v| 
  #   v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"] 
  #   v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL] 
  # end
  boxes = [ 
    { :name => "master",  :ip => MASTER_IP,  :cpus => 2, :memory => 2048 }, 
    { :name => "node-01", :ip => NODE_01_IP, :cpus => 1, :memory => 2048 }, 
  ] 
  boxes.each do |opts| 
    config.vm.define opts[:name] do |box| 
      box.vm.hostname = opts[:name] 
      box.vm.network :private_network, ip: opts[:ip] 
      box.vm.provider "virtualbox" do |vb| 
        vb.cpus = opts[:cpus] 
        vb.memory = opts[:memory] 
      end 
      # box.vm.provision "shell", path:"./install-kubernetes-dependencies.sh" 
      # if box.vm.hostname == "master" then  
      #   box.vm.provision "shell", path:"./configure-master-node.sh" 
      #   end 
      # if box.vm.hostname == "node-01" then ##TODO: create some regex to match worker hostnames 
      #   box.vm.provision "shell", path:"./configure-worker-nodes.sh" 
      # end
    end
  end 
end

Vagrant.configure(2) do |config| 
  config.vm.provision "shell", inline: $script
end