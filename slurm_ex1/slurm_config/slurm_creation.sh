# Create slurm user
# Update and install dependencies
apt-get update
apt-get install -y build-essential
echo "Installing Munge"
apt-get install -y munge
apt-get install -y libmunge-dev

echo "Installing SLURM"
echo "Installing SLURM Worklod Manager"
apt-get install -y slurm-wlm
echo "Installing SLURM Basic Plugins"
apt-get install -y slurm-wlm-basic-plugins
echo "Installing SLURM Controller"
apt-get install -y slurmctld
echo "Installing SLURM Worker Daemon"
apt-get install -y slurmd

# Configure Munge for authentication
echo "Configuring Munge"
dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
chown -R munge: /etc/munge
chmod 0700 /etc/munge

# sudo /usr/sbin/create-munge-key -f
sudo chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

systemctl enable munge
systemctl start munge
systemctl status munge


# Setup directories and permissions
echo "Setting up SLURM directories and permissions"
mkdir -p /var/spool/slurmctld
chown -R slurm: /var/spool/slurmctld 
chmod 755 /var/spool/slurmctld

mkdir -p /var/spool/slurmd
chown -R slurm: /var/spool/slurmd
chmod 755 /var/spool/slurmd

mkdir -p /var/log/slurm
chown -R slurm: /var/log/slurm
chmod 755 /var/log/slurm

# mkdir -p /etc/slurm-llnl/
# chown -R slurm: /etc/slurm-llnl/
# chmod 755 /etc/slurm-llnl/


echo "Configuring SLURM"
chmod +x /home/vagrant/slurm_config/hosts_generator.sh
chmod +x /home/vagrant/slurm_config/slurm_config_generator.sh
chmod +x /home/vagrant/slurm_config/slurmdbd_config_generator.sh

echo "Generating SLURM configuration files"
echo "Generating hosts file"
/home/vagrant/slurm_config/hosts_generator.sh
echo "Generating slurm.conf file"
/home/vagrant/slurm_config/slurm_config_generator.sh
echo "Generating slurmdbd.conf file"
/home/vagrant/slurm_config/slurmdbd_config_generator.sh


echo "Overwriting /etc/hosts with custom hosts file"
sudo mv /home/vagrant/slurm_config/hosts /etc/hosts
echo "Overwriting /etc/slurm/slurm.conf with custom slurm.conf"
sudo mv /home/vagrant/slurm_config/slurm.conf /etc/slurm/slurm.conf
echo "Overwriting /etc/slurm/slurmdbd.conf with custom slurmdbd.conf"
sudo mv /home/vagrant/slurm_config/slurmdbd.conf /etc/slurm/slurmdbd.conf
echo "Successfully configured SLURM controller and worker nodes"


# Ensure slurm.conf is owned by slurm user
echo "Setting permissions for SLURM configuration files"
sudo chown slurm:slurm /etc/slurm/slurm.conf
sudo chown slurm: /etc/slurm/slurm.conf
sudo chmod 644 /etc/slurm/slurm.conf

# sudo cp /vagrant/slurm.conf /etc/slurm-llnl/slurm.conf
# sudo chown slurm:slurm /etc/slurm-llnl/slurm.conf







# Start SLURM controller daemon
sudo systemctl start slurmctld
sudo systemctl enable slurmctld
sudo systemctl start slurmd
sudo systemctl enable slurmd
sudo systemctl status slurmctld
sudo systemctl status slurmd



