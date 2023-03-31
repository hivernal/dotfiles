#!/bin/bash

echo "1) install drivers after installation"
echo "2) install usual packages"
echo "3) install xorg apps"
echo "4) install hyprland"
echo "5) install wm tools"
echo "6) install lsp and dap"
echo "7) install alsa"
echo "8) install pipewire"
echo "9) install pulseaudio"
echo "10) install bluetooth"
echo "11) install themes and icons"
echo "12) install JetBrainsMono Nerd Font"
echo "13) install OhMyZsh"
printf "\nchoose: "
read numbers

for number in $numbers; do
  if [[ $number = 1 ]]; then
    sudo pacman -S intel-ucode xorg xorg-server xorg-apps xf86-video-intel xf86-input-libinput mesa mesa-utils xorg-xinit intel-media-driver libva-utils libva-vdpau-driver libva-intel-driver libvdpau-va-gl vdpauinfo intel-gpu-tools --needed && sudo grub-mkconfig -o /boot/grub/grub.cfg
  fi
  
  if [[ $number = 2 ]]; then
    sudo pacman -S qemu-full virt-viewer make fakeroot firefox firefox-i18n-ru firefox-i18n-en-us firefox-spell-ru gcc nodejs neovim npm python-pip jre-openjdk-headless jre-openjdk jdk-openjdk openjdk-src libreoffice-still libreoffice-still-ru hunspell hunspell-ru hunspell-en_us thunderbird thunderbird-i18n-ru thunderbird-i18n-en-us vlc rsync git gtk-engine-murrine sassc transmission-gtk gparted cmake lsd unzip wget evince unrar curl bash-completion python-pynvim bash-completion --needed
  fi

  if [[ $number = 3 ]]; then
    sudo pacman -S xorg xorg-server xorg-apps xorg-xinit xclip xcb-util-cursor xorg-xbacklight feh gpicview --needed
  fi

   if [[ $number = 4 ]]; then
     sudo pacman -S bemenu-wayland grim slurp jq brightnessctl wayland wlroots qt5-wayland qt6-wayland imv wl-clipboard gnome-polkit --needed
     yay -S hyprland-git waybar-hyprland-git xdg-desktop-portal-hyprland-git emptty
   fi


   if [[ $number = 5 ]]; then
    sudo pacman -S xdg-user-dirs nm-connection-editor lightdm lightdm-gtk-greeter  flameshot lxsession-gtk3 qt5ct qt6ct alacritty lxappearance-gtk3 samba --needed
    sudo systemctl enable lightdm
    # cd ~ && git clone https://aur.archlinux.org/lightdm-settings.git && cd lightdm-settings && makepkg -sric && cd ~ && rm -rf lightdm-settings
   fi

   if [[ $number = 6 ]]; then
    sudo pacman -S lldb clang gdb bash-language-server --needed
    mkdir -p ~/.local/share/nvim/lsp/lua
    mkdir -p ~/.local/share/nvim/dap/cpptools
    cd ~/.local/share/nvim/dap/ && wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.13.8/cpptools-linux.vsix && unzip -d cpptools cpptools-linux.vsix && rm cpptools-linux.vsix
    cd ../lsp && wget https://github.com/sumneko/lua-language-server/releases/download/3.6.4/lua-language-server-3.6.4-linux-x64.tar.gz && tar -xzvf lua-language-server-3.6.4-linux-x64.tar.gz -C lua && rm lua-language-server-3.6.4-linux-x64.tar.gz

   fi

   if [[ $number = 7 ]]; then
    sudo pacman -S alsa-utils alsa-tools --needed
   fi

   if [[ $number = 8 ]]; then
    sudo pacman -S pipewire pipewire-jack pipewire-alsa pipewire-pulse --needed
   fi

   if [[ $number = 9 ]]; then
    sudo pacman -S pulseaudio pulseaudio-bluetooth pulseaudio-alsa pulseaudio-jack pamixer pavucontrol --needed
   fi

   if [[ $number = 10 ]]; then
    sudo pacman -S bluez bluez-utils blueman --needed && sudo systemctl enable bluetooth
   fi

   if [[ $number = 11 ]]; then
    cd ~ && git clone https://github.com/vinceliuice/Qogir-theme.git && cd Qogir-theme && ./install.sh
    cd ~ && git clone https://github.com/vinceliuice/Graphite-gtk-theme.git && cd Graphite-gtk-theme && ./install.sh -t blue --tweaks rimless normal && cd wallpaper && ./install-wallpapers.sh
    cd ~ && git clone https://github.com/vinceliuice/Tela-icon-theme.git && cd Tela-icon-theme && ./install.sh
    cd ~ && git clone https://github.com/vinceliuice/Orchis-theme.git && cd Orchis-theme && ./install.sh --tweaks solid
    cd ~ && rm -rf Qogir-theme Graphite-gtk-theme Tela-icon-theme Orchis-theme
   fi

   if [[ $number = 12 ]]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip && mkdir JetBrainsMono && unzip -d JetBrainsMono JetBrainsMono.zip && mkdir -p ~/.local/share/fonts && mv JetBrainsMono ~/.local/share/fonts/ && rm -rf JetBrainsMono.zip
   fi

   if [[ $number = 13 ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
     cp zshrc ~/.zshrc
   fi

done
