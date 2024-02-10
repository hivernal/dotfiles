#!/bin/bash

programs=(
  qemu-desktop
  docker
  docker-compose
  virt-viewer
  make
  cmake
  gcc
  gdb
  firefox
  firefox-i18n-ru
  firefox-i18n-en-us
  firefox-spell-ru
  gimp
  obs-studio
  fd
  ripgrep
  fzf
  neovim
  python
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
  transmission-gtk
  zip
  unzip
  unrar
  wget
  curl
  evince
  bash-completion
  samba
  htop
  neofetch
  speech-dispatcher
  pkg-config
  yt-dlp
  gtk3
  gtk4
  qt5ct
  qt6ct
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
  qt5-wayland
  qt6-wayland
  qt5-quickcontrols
  qt5-graphicaleffects
)

dwm_packages=(
  xorg-server
  mesa
  feh
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
)

alsa_packages=(
  alsa-utils
  alsa-tools
)

pipewire_packages=(
  wireplumber
  pipewire
  pipewire-audio
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
)

bluetooth_packages=(
  bluez
  bluez-utils
  blueberry
)

themes_packages=(
  wget
  unzip
  gtk-engine-murrine
  sassc
)

pandoc_packages=(
  pandoc-cli
  texlive-xetex
  texlive-fontsrecommended
  texlive-latex
  texlive-latexrecommended
)

LOG="install.log"
HIVERNAL="https://github.com/hivernal"
CONFIG_PATH="${HOME}/.config"

show_progress() {
  pid="$1"
  while ps | grep ${pid} &> /dev/null; do
    echo -n "."
    sleep 2
  done
  echo -en "Done!\n"
}

progress_wrapper() {
  func="$1"
  "${func}" "$@" &
  pid=$!
  show_progress ${pid}
  wait ${pid}
  return $?
}

install_yay() {
  if [[ -f /bin/yay ]]; then
    return 0
  fi
  sudo pacman -S --noconfirm --needed go git base-devel &>> "${LOG}" &&
  git clone https://aur.archlinux.org/yay.git &>> "${LOG}" &&
  cd yay &&
  makepkg -si --noconfirm &>> "${LOG}" &&
  cd .. && rm -rf yay &&
  yay -Sy &> /dev/null
}

install_packages() {
  packages=("$@")
  yay -S --needed --noconfirm "${packages[@]}" &>> "${LOG}"
}

install_dwm() {
  install_packages "${dwm_packages[@]}" &&
  cp .xinitrc "${HOME}" &&
  cp .xprofile "${HOME}" &&
  cp -r .config/picom "${CONFIG_PATH}" &&
  sudo mkdir -p /usr/share/X11/xorg.conf.d &&
  sudo cp -r xorg.conf.d/* "/usr/share/X11/xorg.conf.d" &&

  dwm_path="${CONFIG_PATH}/dwm" &&
  git clone "${HIVERNAL}/dwm.git" "${dwm_path}" &>> "${LOG}" &&

  sudo make -C "${dwm_path}" install &>> "${LOG}" &&
  make -C "${dwm_path}" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/config.h" &&
  mkdir -p "${HOME}/.dwm" &&
  cp "${dwm_path}/autostart.sh" "${HOME}/.dwm/" &&

  sudo make -C "${dwm_path}/slstatus" install &>> "${LOG}" &&
  make -C "${dwm_path}/slstatus" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/slstatus/config.h" &&

  sudo make -C "${dwm_path}/dmenu" install &>> "${LOG}" &&
  make -C "${dwm_path}/dmenu" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/dmenu/config.h" &&

  sudo make -C "${dwm_path}/st" install &>> "${LOG}" &&
  make -C "${dwm_path}/st" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/st/config.h" &&

  sudo make -C "${dwm_path}/st/scroll" install &>> "${LOG}" &&
  make -C "${dwm_path}/st/scroll" clean &>> "${LOG}" &&
  rm -f "${dwm_path}/st/scroll/config.h"
}

install_hyprland() {
  install_packages "${hyprland_packages[@]}" &&
  sudo systemctl enable sddm &>> "${LOG}" &&
  sudo mkdir /etc/sddm.conf.d &&
  sudo cp sddm/default.conf /etc/sddm.conf.d &&
  sudo cp sddm/wayland-session /usr/share/sddm/scripts/ &&
  git clone https://github.com/MarianArlt/sddm-chili.git  &>> "${LOG}" &&
  sudo cp sddm/theme.conf sddm-chili/theme.conf &&
  cp pictures/groot-dark.png sddm-chili/assets &&
  sudo mv sddm-chili /usr/share/sddm/themes &&
  git clone "${HIVERNAL}/hypr.git" "${CONFIG_PATH}/hypr"  &>> "${LOG}" &&
  cp -r .config/foot "${CONFIG_PATH}" &&
  cp .wprofile "${HOME}"
}

install_themes() {
  install_packages "${themes_packages[@]}" &&
  git clone https://github.com/vinceliuice/Qogir-theme.git &>> "${LOG}" &&
  cd Qogir-theme &&
  sudo bash install.sh -d /usr/share/themes &>> "${LOG}" &&
  cd .. &&
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git &>> "${LOG}" &&
  cd Qogir-icon-theme &&
  sudo bash install.sh -d /usr/share/icons &>> "${LOG}" &&
  cd .. && rm -rf Qogir* &&
  font_path="${HOME}/.local/share/fonts/JetBrainsMono" &&
  mkdir -p "${font_path}" &&
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip &>> "${LOG}" &&
  unzip -d "${font_path}" JetBrainsMono.zip &>> "${LOG}" &&
  rm JetBrainsMono.zip
}

> "${LOG}"

echo -en "Installing yay"
if ! progress_wrapper install_yay; then
  echo -en "Failed to install yay\n"
  exit
fi
echo -en "Yay has been installed\n\n"

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
echo -en "Copying has been finished\n\n"

echo "1) install programs"
echo "2) install dwm"
echo "3) install hyprland"
echo "4) install alsa"
echo "5) install pipewire"
echo "6) install bluetooth"
echo "7) install themes and icons"
echo "8) install pandoc"
echo "choose: "
read numbers

for number in "${numbers}"; do
  case "${number}" in
    1)
      echo -en "Installing programs"
      if ! progress_wrapper install_packages "${programs[@]}"; then
        echo -en "Failed to install programs\n"
        exit
      fi
      echo -en "Programs has been installed\n"
      ;;
    2)
      echo -en "Installing dwm"
      if ! progress_wrapper install_dwm; then
        echo -en "Failed to install dwm\n"
        exit
      fi
      echo -en "Dwm has been installed\n"
      ;;
    3)
      echo -en "Installing hyprland packages\n"
      if ! progress_wrapper install_hyprland; then
        echo -en "Failed to install hyprland packages\n"
        exit
      fi
      echo -en "Hyprland packages has been installed\n"
      ;;
    4)
      echo -en "Installing alsa\n"
      if ! progress_wrapper install_packages "${alsa_packages[@]}"; then
        echo -en "Failed to install alsa\n"
        exit
      fi
      echo -en "Alsa has been installed\n"
      ;;
    5)
      echo -en "Installing pipewire\n"
      if ! progress_wrapper install_packages "${pipewire_packages[@]}"; then
        echo -en "Failed to install pipewire\n"
        exit
      fi
      echo -en "Pipewire has been installed\n"
      ;;
    6)
      echo -en "Installing bluetooth\n"
      if ! progress_wrapper install_packages "${bluetooth_packages[@]}"; then
        echo -en "Failed to install bluetooth\n"
        exit
      fi
      sudo systemctl enable bluetooth &>> "${LOG}"
      echo -en "Pipewire has been installed\n"
      ;;
    7)
      echo -en "Installing themes\n"
      if ! progress_wrapper install_themes; then
        echo -en "Failed to install themes\n"
        exit
      fi
      echo -en "Themes has been installed\n"
      ;;
    8)
      echo -en "Installing pandoc\n"
      if ! progress_wrapper install_packages "${pandoc_packages[@]}"; then
        echo -en "Failed to install pandoc\n"
        exit
      fi
      echo -en "Pandoc has been installed\n"
      ;;
  esac
done
