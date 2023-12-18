#!/bin/bash

#####################################################################
# Debian 12.2 install script
#####################################################################
# Download directory
downloads="/home/$USER/Downloads/"
#####################################################################

# Add repositories 
echo -e "\nAdding repositories \n"
sleep 2

echo 'deb http://deb.debian.org/debian bookworm main contrib non-free' | sudo tee -a /etc/apt/sources.list
echo 'deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
echo 'deb http://deb.debian.org/debian bookworm-updates main contrib non-free' | sudo tee -a /etc/apt/sources.list

# update and upgrade system
echo -e "\nUpdating and upgrading system\n"
sleep 2

sudo apt update && sudo apt upgrade -y

# setup crontab files 
echo -e "\nConfiguring Crontab\n"
sleep 2

echo -e "\ncreate crontab file and set crontab editor for $USER\n"
sleep 2

echo 'export EDITOR=nano' >> ~.bashrc
crontab -u dataspy -e

echo -e "\ncreate crontab file and set crontab editor for root\n"
sleep 2

sudo echo 'export EDITOR=nano' >> /root/.bashrc
sudo crontab -u root -e

echo -e "\nAdding crontab jobs\n"
sleep 2

(crontab -l ; echo "@reboot nordvpn c US") | crontab
(sudo crontab -l ; echo "@reboot sudo /opt/lampp/lampp start") | sudo crontab

# Install base packages
echo -e "\nInstalling packages\n"
sleep 2

sudo apt install wget curl gdebi-core coreutils build-essential dkms software-properties-common gpg xfce4-panel-profiles vnstat terminator git-all nethogs iftop net-tools tcpdump gparted gnome-calculator default-jre libreoffice-java-common sox libsox-fmt-all lame flac lame wodim cdparanoia mpv vlc growisofs genisoimage ruby-full htop gscan2pdf magic-wormhole rkhunter clamav clamav-daemon lsscsi lshw htop gimp debsums software-properties-gtk  -y 

cd $downloads

# Install VisualStudioCode
echo -e "\nInstalling VisualStudioCode\n"
sleep 2

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code -y

# Install Signal
echo -e "\nInstalling Signal\n"
sleep 2

curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-desktop.list
sudo apt update
sudo apt install signal-desktop -y

# Install Discord
echo -e "\nInstalling Discord\n"
sleep 2

wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install ./discord.deb -y

# Install Steam
echo -e "\nInstalling Steam\n"
sleep 2

sudo apt install apt-transport-https dirmngr ca-certificates libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-glx:i386 -y
sudo dpkg --add-architecture i386
curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null
echo deb "[arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam" | sudo tee /etc/apt/sources.list.d/steam.list
sudo apt update
sudo apt install steam-launcher -y

# Install Zoom
echo -e "\nInstalling Zoom\n"
sleep 2

sudo apt install libegl1-mesa libxcb-cursor0 libxcb-xtest0 -y
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install ./zoom_amd64.deb -y

# Install Skype
echo -e "\nInstalling Skype\n"
sleep 2

curl -fsSL https://repo.skype.com/data/SKYPE-GPG-KEY | sudo gpg --dearmor | sudo tee /usr/share/keyrings/skype.gpg > /dev/null
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/skype.gpg] https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skype.list
sudo apt update
sudo apt install skypeforlinux -y

# Install Virtualbox
echo -e "\nInstalling Virtualbox\n"
sleep 2

wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install virtualbox-7.0 -y

# Install Ollama
echo -e "\nInstalling Ollama\n"
sleep 2

curl https://ollama.ai/install.sh | sh

# Install and Configure LAMPP
echo -e "\nInstalling LAMPP\n"
sleep 2

wget https://sourceforge.net/projects/xampp/files/XAMPP%20Linux/8.2.12/xampp-linux-x64-8.2.12-0-installer.run
sudo chmod u+x xampp-linux-*-installer.run
sudo ./xampp-linux-*-installer.run

sudo mkdir /opt/lampp/htdocs/www
sudo chmod -R a+rwx /opt/lampp/htdocs/www
sudo sed -i -e 's/display_errors=Off/display_errors=On/g' /opt/lampp/etc/php.ini

# Install and Configure RKHunter
echo -e "\nUpdating and Configuring RKHunter\n"
sleep 2

sudo rkhunter --update

sudo sed -i -e 's/UPDATE_MIRRORS=0/UPDATE_MIRRORS=1/g' /etc/rkhunter.conf
sudo sed -i -e 's/MIRRORS_MODE=1/MIRRORS_MODE=0/g' /etc/rkhunter.conf
sudo sed -i -e 's/WEB_CMD="\/bin\/false"/WEB_CMD=""/g' /etc/rkhunter.conf

# Configure ClamAV
echo -e "\nUpdating and Configuring RKHunter\n"
sleep 2

clamscan --version
sleep 2
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam
sudo systemctl enable clamav-freshclam
systemctl | grep clam

# Configure Aliases 
echo -e "\nConfiguring Aliases\n"
sleep 2

cd /home/$USER/

echo 'alias wget="wget -c --limit-rate=2m"' >> ~/.bash_aliases
echo 'source /mnt/Storage/Docs/Programming/Bash/.my_custom_functions' >> ~.bashrc

# Create mount points and edit fstab file for usb drives
echo -e "\nCreating mount points and configuring fstab\n"
sleep 2

echo 'UUID=-0 /mnt/Storage ext4    defaults        0 0' | sudo tee -a /etc/fstab
echo 'UUID=-0 /mnt/VMs ext4    defaults        0 0' | sudo tee -a /etc/fstab
mount -av

# Load Xfce profile settings
echo -e "\nLoading Xfce profile settings\n"
sleep 2
xfce4-panel-profiles load /mnt/Storage/Docs/current-config.tar.bz2

# Clean up
echo -e "\nCleaning up Downloads\n"
sleep 2

cd $downloads

sudo rm *.deb
sudo rm *.run
sudo rm *.tar.gz

echo -e "\nInstallation Finished\n"
sleep 2
