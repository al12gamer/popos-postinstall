#!/usr/bin/env bash

PACKAGE_LIST=(
	vim
	zsh
	lutris
	steam
	slack-desktop
	discord
	vlc
	gamemode
	mcomix3
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
	radeontop
	inxi
	ppa-purge
	heif-gdk-pixbuf
		
)

FLATPAK_LIST=(
	org.telegram.desktop
	net.veloren.airshipper
	net.davidotek.pupgui2
	com.usebottles.bottles
	org.signal.Signal
)

# gnome settings
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# add flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add third party software

# add protonup-qt
flatpak install flathub net.davidotek.pupgui2 -y
 
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


# grab codium
echo "Grabbing VSCode without telemetry"
sleep 1
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg 
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list 
sudo apt update -yq && sudo apt install codium -yq

# grab ukuu alternative
sudo add-apt-repository ppa:cappelikan/ppa -y
sudo apt update -y && sudo apt install -y mainline

# setup xanmod
echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
sudo apt update -y && sudo apt install linux-xanmod -y

# grab fresher mesa drivers (mainly for Intel Xe or AMD RDNA2 or newer)
sudo add-apt-repository ppa:kisak/kisak-mesa -y

# upgrade packages
sudo apt clean -y
sudo apt update -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

# open github to remind me to set up github
firefox https://github.com
