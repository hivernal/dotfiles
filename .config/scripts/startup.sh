#!/bin/bash

echo "1) install xorg and intel drivers"
echo "2) install usual packages"
echo "3) install xorg wm tools"
echo "4) install hyprland"
echo "5) install alsa"
echo "6) install pipewire"
echo "7) install bluetooth"
echo "8) install themes and icons"
printf "\nchoose: "
read numbers

for number in ${numbers}; do
  if [[ ${number} = 1 ]]; then
    sudo pacman -S xorg-server mesa vulkan-intel xorg-xinit intel-media-driver libva-vdpau-driver libvdpau-va-gl --needed
  fi
  
  if [[ ${number} = 2 ]]; then
    sudo pacman -S qemu-desktop docker docker-compose virt-viewer make fakeroot firefox gimp firefox-i18n-ru firefox-i18n-en-us firefox-spell-ru gcc fd ripgrep fzf go gdb neovim python-pip libreoffice-still libreoffice-still-ru hunspell hunspell-ru hunspell-en_us thunderbird thunderbird-i18n-ru thunderbird-i18n-en-us rsync git gtk-engine-murrine sassc transmission-gtk gparted cmake unzip zip wget evince unrar curl bash-completion samba htop neofetch speech-dispatcher yt-dlp --needed
  fi

  if [[ ${number} = 3 ]]; then
    sudo pacman -S dunst polkit-gnome picom xclip brightnessctl feh imv mpv obs-studio flameshot nm-connection-editor qt5ct qt6ct lxappearance-gtk3 xdg-user-dirs gtk3 gtk4 --needed
  fi

   if [[ ${number} = 4 ]]; then
     sudo pacman -S bemenu-wayland dunst grim slurp jq brightnessctl wayland wlroots qt5-wayland qt6-wayland imv wl-clipboard gnome-polkit --needed
     yay -S hyprland-git waybar-hyprland-git xdg-desktop-portal-hyprland-git emptty
   fi

   if [[ ${number} = 5 ]]; then
    sudo pacman -S alsa-utils alsa-tools --needed
   fi

   if [[ ${number} = 6 ]]; then
    sudo pacman -S wireplumber pipewire pipewire-audio pipewire-jack pipewire-alsa pipewire-pulse --needed
   fi

   if [[ ${number} = 7 ]]; then
    sudo pacman -S bluez bluez-utils blueberry --needed && sudo systemctl enable bluetooth
   fi

   if [[ ${number} = 8 ]]; then
    cd && git clone https://github.com/vinceliuice/Qogir-theme.git &&
    cd Qogir-theme && ./install.sh
    cd && git clone https://github.com/vinceliuice/Qogir-icon-theme.git &&
    cd Qogir-icon-theme && ./install.sh
    cd && rm -rf Qogir*
    mkdir -p ${HOME}/.local/share/fonts/JetBrainsMono &&
    cd ${HOME}/.local/share/fonts/JetBrainsMono &&
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip &&
    unzip JetBrainsMono.zip && rm JetBrainsMono.zip
   fi
done
