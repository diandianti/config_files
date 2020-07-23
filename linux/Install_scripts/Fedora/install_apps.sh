#!/usr/bin/env bash
clear

SCRIPT_DIR="$(dirname "$0")"
LOCATION="~/Downloads"

cd $SCRIPT_DIR
source ../common.sh

# Check System as the script only works on Ubintu 20.04 based OSs
check_os # Produces $OS and $VER from common.sh

if [[ "$OS" == "Fedora" ]]; then
    echo ""
else 
    echo "Scripts is not for $OS"
    exit
fi

if [[ "$VER" != "32" ]]; then
    echo "\n Script is not tested on version $VER"
    pause "Press [Enter] still proceed"
fi

check_root # Checks sudo privlages of the shell from common.sh

clear
cd $LOCATION
tell_location
pause "/nPress [Enter] to continue installing apps"

echo "Updating system"
sudo dnf update -y
clear

echo "configuring Repositorires"
# Rpm Fusion 
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf groupupdate core
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf install rpmfusion-free-release-tainted
sudo dnf install libdvdcss
sudo dnf install rpmfusion-nonfree-release-tainted
sudo dnf install \*-firmware
echo -e "\nConfigured rpm fusion\n"
pause "Press [Enter] to continue"


echo "Installing dnf apps"
sudo dnf install -y vlc mono-complete goland qt-devel cmake gnome-tweak-tool xfce4-terminal kvantum qt5ct lxappearance 
echo -e "\nInstalled many apps\n"
pause "Press [Enter] to continue"


echo "Installing Fedy"
sudo dnf copr enable kwizart/fedy
sudo dnf install fedy -y
pause "\nPress [Enter] to continue"

echo "Installing other apps"
sleep 1

echo "Installing Visual Studio Codecheck_root # Checks sudo privlages of the shell from common.sh
"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install code


echo "Installing MailSpring"
cd $LOCATION
wget -O mailspring.rpm https://updates.getmailspring.com/download?platform=linuxRpm -q --show-progress
sudo dnf install ./mailspring.rpm -y
clear

echo "Installing Virtualbox"
wget -O virtualbox.rpm https://download.virtualbox.org/virtualbox/6.1.12/VirtualBox-6.1-6.1.12_139181_fedora32-1.x86_64.rpm -q --show-progress
sudo dnf install ./virtualbox.rpm -y 

echo ""
pause "Press [Enter] to continue"
clear

echo "Installing and setting up vim"
sudo dnf install vim
if [[ ! -f "~/.vimrc" ]]; then
    cd ~
    ln -s ~/Documents/Github/config_files/.vimrc
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo -e "\nAll Done\n"
pause "Press [Enter] to continue to main menu"