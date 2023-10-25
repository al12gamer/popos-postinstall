#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
 	cowsay
  	asciinema
	discord
	vlc
 	mcomix3
	htop
	gnome-boxes
	gnome-tweaks
	python3
	youtube-dl
	neofetch
	nmap
	pv
	wget
	wine
	radeontop
	inxi
	heif-gdk-pixbuf
	kde-standard	
 	curl
  	cpu-x
   	build-essential 
)

FLATPAK_LIST=(
	net.veloren.airshipper
	org.mozilla.firefox
 	org.signal.Signal
  	org.telegram.desktop
)

# gnome settings
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software
 
# update repositories

sudo apt-get update -yq

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo apt list --installed | grep -q "^\<$package_name\>"; then
		echo "installing $package_name..."
		sleep .5
		sudo apt-get install "$package_name" -y -q
		echo "$package_name installed"
	else
		echo "$package_name already installed"
	fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q $flatpak_name; then
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done


# grab codium
echo "Grabbing VSCode without telemetry"
sleep 2
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 
sudo apt update -y && sudo apt install codium -y

# remove default firefox and install flatpak
sudo apt purge firefox -y

# setup xanmod for better kernel scheduler experience
echo "grabbing xanmod kernel, as it's more up to date"
sleep 2
cd
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update -y && sudo apt install linux-xanmod -y

# grab brave
echo "Grabbing the Brave web browser as an alternative to chrome"
sleep 2
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-relaease.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y && sudo apt install brave-browser -y

# upgrade packages
sudo apt clean -y
sudo apt update -y
sudo apt install -f
sudo dpkg --configure -a
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

# grab mullvad
cd /home/$USER/Downloads && wget --content-disposition https://mullvad.net/download/app/deb/latest && sudo dpkg -i Mullvad*.deb
cd

echo "ADDING MUP BASH ALIAS"
sleep 4
alias -p mup='cd /home/$USER/Downloads && sudo rm -r Mullvad*.deb && sudo apt purge mullvad-vpn -y && wget --content-disposition https://mullvad.net/download/app/deb/latest && sudo dpkg -i Mullvad*.deb && cowsay DONE NOW'
alias -p upd='sudo apt clean && sudo apt update -y && sudo dpkg --configure -a && sudo apt install -f && sudo apt full-upgrade -y && sudo apt autoremove --purge'
sleep 4
echo "DONESIES"
sleep 2
