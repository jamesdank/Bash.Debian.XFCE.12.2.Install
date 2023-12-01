#!/bin/bash

#####################################################################
# Debian 12.2 install script
#####################################################################
# Download directory
DOWNLOADS="/home/$USER/Downloads/"
#####################################################################

cd $DOWNLOADS

# update and upgrade system
echo -e "\nUpdating and upgrading system\n"
sleep 2
sudo apt update && sudo apt upgrade -y

# Install base packages
echo -e "\nInstalling packages\n"
sleep 2
sudo apt install wget curl gdebi-core coreutils build-essential software-properties-common gpg vnstat terminator git-all nethogs iftop net-tools tcpdump tor gparted gnome-calculator macchanger default-jre libreoffice-java-common sox libsox-fmt-all lame flac ffmpeg lsdvd handbrake-cli vlc abcde genisoimage ruby-full htop gscan2pdf magic-wormhole rkhunter lsscsi lshw htop gimp -y

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
sudo apt install apt-transport-https dirmngr ca-certificates -y
sudo dpkg --add-architecture i386
curl -s http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo tee /usr/share/keyrings/steam.gpg > /dev/null
echo deb "[arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam" | sudo tee /etc/apt/sources.list.d/steam.list
sudo apt update
sudo apt install libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-glx:i386 steam-launcher -y
apt-cache policy steam-launcher

# Install Visual Studio Code
echo -e "\nInstalling Visual Studio Code\n"
sleep 2
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code -y

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


# Configure crontab
echo -e "\nConfiguring Crontab\n"
sleep 2

echo -e "\nSet crontab editor for $USER\n"
sleep 2
select-editor

echo -e "\nSet crontab editor for Root\n"
sleep 2
sudo select-editor

(sudo crontab -l ; echo "@reboot sudo /opt/lampp/lampp start") | sudo crontab

# Configure Aliases 
echo -e "\nConfiguring Aliases\n"
sleep 2

cd /home/$USER/

echo 'alias mjm="/media/dataspy/Laptop.Storage/Docs/Programming/Bash/midjourney.move.sh"' >> .bashrc
echo 'alias weather="curl -s 'wttr.in/{tokyo,angeles+city,pattaya,siem reap,medellin,puerto+vallarta,merida,mesa,chicago}?format=%l+%t+%c\n+%20Time:%20%T\n+%20Sunrise:%20%S\n+%20Sunset:%20%s\n'"' >> .bashrc
echo 'alias nh3="sudo nethogs -v 3"' >> .bashrc
echo 'alias bndwth="watch -n 600 vnstat"' >> .bashrc
echo 'alias update="/media/dataspy/Laptop.Storage/Docs/Programming/Bash/update.sh"' >> .bashrc
echo 'alias scan="sudo /usr/bin/rkhunter --update --report-warnings-only --nocolors --skip-keypress > '/media/dataspy/Laptop.Storage/Docs/Logs/rkhunter_warnings-$(date +%Y-%m-%d_%H%M%S)'"' >> .bashrc
echo 'alias wget="wget -c --limit-rate=2m"' >> .bashrc

# Clean up
echo -e "\nCleaning up Downloads\n"
sleep 2

cd $DOWNLOADS

sudo rm *.deb
sudo rm *.run

echo -e "\nInstallation Finished\n"
sleep 2
