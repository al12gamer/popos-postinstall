#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	calibre
	zsh
	lutris
	steam
	slack-desktop
	discord
	legendary
	vlc
	gamemode
	mcomix3
	qbittorrent
	htop
	gnome-boxes
	handbrake
	gnome-tweaks
	python3
	youtube-dl
	neofetch
	nmap
	pv
	wget
	java-latest-openjdk
	wine
	nvtop
	inxi
	
	
)

FLATPAK_LIST=(
	com.github.calo001.fondo
	io.lbry.lbry-app
	org.telegram.desktop
	com.mojang.Minecraft
	org.gnome.clocks

)

# gnome settings
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# install development tools 
#sudo dnf groupinstall "Development Tools" -yq

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software

# add Proton Updater from Auna Naseef
echo "Adding a Proton Updater script from Auna Naseef on Github. Cd into ~/protonge-updater to update your version in the future."
sleep 1
git clone https://github.com/AUNaseef/protonge-updater.git

# add virtio
# add this for ubuntu based distros
 
# add jotta-cli for backups
# WIP echo Jottacloud.txt > /etc/yum.repos.d/JottaCLI.repo

# update repositories

sudo apt-get update -yq

# iterate through packages and installs them if not already installed
for package_name in ${PACKAGE_LIST[@]}; do
	if ! sudo apt list --installed | grep -q "^\<$package_name\>"; then
		echo "installing $package_name..."
		sleep .5
		sudo apt-get install "$package_name" -y
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

# grab the pre-5.13 stable Proton release
echo "Grabbing Proton 5.9-GE-8 and extracting it to the Proton folder here, please move this to your new steam compatibility tools folder"
sleep 1
wget https://github.com/GloriousEggroll/proton-ge-custom/releases/download/5.9-GE-8-ST/Proton-5.9-GE-8-ST.tar.gz
mkdir ~/Proton
tar -xvf Proton-5.9-GE-8-ST.tar.gz ~/Proton

# grab codium
echo "Grabbing VSCode without telemetry"
sleep 1
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 
sudo apt update -yq && sudo apt install codium -yq

# grab ukuu alternative
sudo add-apt-repository ppa:cappelikan/ppa
sudo apt update -y && sudo apt install -y mainline

# upgrade packages
sudo apt-get upgrade -yq
sudo apt autoremove -yq
