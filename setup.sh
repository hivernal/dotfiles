#!/bin/bash

programs=(
  qemu-desktop
  docker
  docker-compose
  virt-viewer
  make
  fakeroot
  firefox
  gimp
  firefox-i18n-ru
  firefox-i18n-en-us
  firefox-spell-ru
  gcc
  fd
  ripgrep
  fzf
  gdb
  neovim
  python
  obs-studio
  python-pip
  libreoffice-still
  libreoffice-still-ru
  hunspell
  hunspell-ru
  hunspell-en_us
  thunderbird
  thunderbird-i18n-ru
  thunderbird-i18n-en-us
  rsync
  git
  gtk-engine-murrine
  sassc
  transmission-gtk
  cmake
  zip
  unzip
  unrar
  wget
  evince
  curl
  bash-completion
  samba
  htop
  neofetch
  speech-dispatcher
  pkg-config
  yt-dlp
)

hyprland_packages=(
  hyprland
  xdg-desktop-portal-hyprland
  waybar
  bemenu-wayland
  dunst
  foot
  swaybg
  grim
  slurp
  jq
  wl-clipboard
  imv
  mpv
  sddm-git
  nwg-look-bin
  gtk3
  gtk4
  qt5-wayland
  qt6-wayland
  qt5ct
  qt6ct
  qt5-quickcontrols
  qt5-graphicaleffects
)

dwm_packages=(
  xorg-server
  mesa
  vulkan-intel
  xorg-xinit
  intel-media-driver
  libva-vdpau-driver
  libvdpau-va-gl
  dunst
  flameshot
  xclip
  imv
  mpv
  lxappearance-gtk3
  gtk3
  gtk4
  qt5ct
  qt6ct
)

alsa_packages=(
  alsa-utils
  alsa-tools
)

pipewire_packages=(
  wireplumber
  pipewire
  pipewire-audio
  pipewire-jack
  pipewire-alsa
  pipewire-pulse
)

bluetooth_packages=(
  bluez
  bluez-utils
  blueberry
)

LOG="install.log"
HIVERNAL="https://github.com/hivernal"
CONFIG_PATH="${HOME}/.config"

show_progress() {
  while ps | grep $1 &> /dev/null; do
    echo -n "."
    sleep 2
  done
  echo -en "Done!\n"
  sleep 2
}

install_yay() {
  if [[ -f /bin/yay ]]; then
    return 0
  fi
  sudo pacman -S --noconfirm --needed go git base-devel &>> "${LOG}"
  git clone https://aur.archlinux.org/yay.git &>> "${LOG}"
  cd yay
  makepkg -si --noconfirm &>> "${LOG}" &
  show_progress $!
  cd ..
  rm -rf yay
  yay -Sy &> /dev/null
  if [[ -f /bin/yay ]]; then
    return 0
  else
    return 1
  fi
}

install_packages() {
  packages=("$@")
  if ! yay -S --needed --noconfirm "${packages[@]}" &>> "${LOG}"; then
    return 1
  fi
  return 0
}

install_dwm() {
  if ! install_packages "${dwm_packages[@]}"; then
    return 1
  fi
  return 0
  cp .xinitrc "${HOME}"
  cp .xprofile "${HOME}"
  cp -r .config/picom "${CONFIG_PATH}"

  dwm_path="${CONFIG_PATH}/dwm"
  git clone "${HIVERNAL}/dwm.git" "${dwm_path}" &>> "${LOG}"

  sudo make -C "${dwm_path}" install &>> "${LOG}" &&
  make -C "${dwm_path}" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/config.h"

  sudo make -C "${dwm_path}/slstatus" install &>> "${LOG}" &&
  make -C "${dwm_path}/slstatus" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/slstatus/config.h"

  sudo make -C "${dwm_path}/dmenu" install &>> "${LOG}" &&
  make -C "${dwm_path}/dmenu" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/dmenu/config.h"

  sudo make -C "${dwm_path}/st" install &>> "${LOG}" &&
  make -C "${dwm_path}/st" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/st/config.h"

  sudo make -C "${dwm_path}/st/scroll" install &>> "${LOG}" &&
  make -C "${dwm_path}/st/scroll" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/st/scroll/config.h"
}

install_hyprland() {
  if ! install_packages "${hyprland_packages[@]}"; then
    return 1
  fi
  sudo systemctl enable sddm &>> "${LOG}"
  sudo mkdir /etc/sddm.conf.d
  sudo cp sddm/default.conf /etc/sddm.conf.d
  sudo cp sddm/wayland-session /usr/share/sddm/scripts/
  git clone https://github.com/MarianArlt/sddm-chili.git  &>> "${LOG}"
  sudo cp sddm/theme.conf sddm-chili/theme.conf
  cp pictures/groot-dark.png sddm-chili/assets
  sudo mv sddm-chili /usr/share/sddm/themes
  git clone "${HIVERNAL}/hypr.git" "${CONFIG_PATH}/hypr"  &>> "${LOG}"
  cp -r .config/foot "${CONFIG_PATH}"
  cp .wprofile "${HOME}"
  return 0
}

install_themes() {
  git clone https://github.com/vinceliuice/Qogir-theme.git &>> "${LOG}"
  cd Qogir-theme
  ./install.sh
  cd ..
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git &>> "${LOG}"
  cd Qogir-icon-theme
  ./install.sh
  cd .. && rm -rf Qogir*
  font_path="${HOME}/.local/share/fonts/JetBrainsMono"
  mkdir -p "${font_path}"
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip &>> "${LOG}"
  unzip -d "${font_path}" JetBrainsMono.zip &>> "${LOG}"
  rm JetBrainsMono.zip
}

> "${LOG}"

echo -en "Installing yay\n"
if ! install_yay; then
  echo -en "Failed to install yay\n"
  exit
fi
echo -en "Yay has been installed\n"

echo -en "Copying pictures and scripts\n"
cp .bashrc "${HOME}"
mkdir -p "${HOME}/.local/bin"
cp scripts/grimblast scripts/backup.sh "${HOME}/.local/bin"
mkdir -p "${HOME}/pictures"
cp pictures/* "${HOME}/pictures/"
mkdir -p "${HOME}/documents/qemu"
cp scripts/run.sh "${HOME}/documents/qemu/"
mkdir -p "${CONFIG_PATH}/"
cp -r .config/systemd .config/user-dirs.dirs .config/dunst "${CONFIG_PATH}"
mkdir -p "${HOME}/music" "${HOME}/desktop" "${HOME}/videos" "${HOME}/templates" "${HOME}/downloads"
echo -en "Copying has been finished\n"

echo ""
echo "1) install usual packages"
echo "2) install dwm"
echo "3) install hyprland"
echo "4) install alsa"
echo "5) install pipewire"
echo "6) install bluetooth"
echo "7) install themes and icons"
echo "\nchoose: "
read numbers

case ${number} in
  1)
    echo -en "Installing programs\n"
    if ! install_packages "${programs[@]}"; then
      echo -en "Failed to install programs\n"
      exit
    fi
    echo -en "Programs has been installed\n"
    ;;
  2)
    echo -en "Installing dwm packages\n"
    if ! install_dwm; then
      echo -en "Failed to install dwm packages\n"
      exit
    fi
    echo -en "Dwm packages has been installed\n"
    ;;
  3)
    echo -en "Installing hyprland packages\n"
    if ! install_hyprland; then
      echo -en "Failed to install hyprland packages\n"
      exit
    fi
    echo -en "Hyprland packages has been installed\n"
    ;;
  4)
    echo -en "Installing alsa\n"
    if ! install_packages "${alsa_packages[@]}"; then
      echo -en "Failed to install alsa\n"
      exit
    fi
    echo -en "Alsa has been installed\n"
    ;;
  5)
    echo -en "Installing pipewire\n"
    if ! install_packages "${pipewire_packages[@]}"; then
      echo -en "Failed to install pipewire\n"
      exit
    fi
    echo -en "Pipewire has been installed\n"
    ;;
  6)
    echo -en "Installing bluetooth\n"
    if ! install_packages "${bluetooth_packages[@]}"; then
      echo -en "Failed to install bluetooth\n"
      exit
    fi
    sudo systemctl enable bluetooth &>> "${LOG}"
    echo -en "Pipewire has been installed\n"
    ;;
  7)
    echo -en "Installing themes\n"
    install_themes
    echo -en "Themes has been installed\n"
    ;;
esac
