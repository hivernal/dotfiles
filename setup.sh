#!/bin/bash

programs=(
  tmux
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
  transmission-cli
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
  xdg-user-dirs
)

hyprland_packages=(
  tmux
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
  brightnessctl
  nm-connection-editor
)

dwm_packages=(
  xorg-server
  xorg-xinit
  picom
  tmux
  nm-connection-editor
  brightnessctl
  mesa
  feh
  vulkan-intel
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
  "${func}" "$@" &>> ${LOG} &
  pid=$!
  show_progress ${pid}
  wait ${pid}
  return $?
}

install_yay() {
  if [[ -f /bin/yay ]]; then
    return 0
  fi
  sudo pacman -S --noconfirm --needed go git base-devel &&
  git clone https://aur.archlinux.org/yay.git &&
  cd yay &&
  makepkg -si --noconfirm &&
  cd .. && rm -rf yay &&
  yay -Sy &> /dev/null
}

install_packages() {
  packages=("$@")
  install_yay &&
  yay -S --needed --noconfirm "${packages[@]}"
}

install_dwm() {
  if [[ -d "${CONFIG_PATH}/dwm" ]]; then
    rm -rf "${CONFIG_PATH}/dwm"
  fi
  install_packages "${dwm_packages[@]}" &&
  cp .xinitrc "${HOME}" &&
  cp .xprofile "${HOME}" &&
  cp -r .config/picom "${CONFIG_PATH}" &&
  sudo mkdir -p /usr/share/X11/xorg.conf.d &&
  sudo cp -r xorg.conf.d/* /etc/X11/xorg.conf.d/ &&

  dwm_path="${CONFIG_PATH}/dwm" &&
  git clone "${HIVERNAL}/dwm.git" "${dwm_path}" &&

  sudo make -C "${dwm_path}" install &&
  make -C "${dwm_path}" clean &&
  rm -f "${dwm_path}/config.h" &&
  mkdir -p "${HOME}/.dwm" &&
  cp "${dwm_path}/autostart.sh" "${HOME}/.dwm/" &&

  sudo make -C "${dwm_path}/slstatus" install &&
  make -C "${dwm_path}/slstatus" clean &&
  rm -f "${dwm_path}/slstatus/config.h" &&

  sudo make -C "${dwm_path}/dmenu" install &&
  make -C "${dwm_path}/dmenu" clean &&
  rm -f "${dwm_path}/dmenu/config.h" &&

  sudo make -C "${dwm_path}/st" install &&
  make -C "${dwm_path}/st" clean &&
  rm -f "${dwm_path}/st/config.h"
}

install_hyprland() {
  if [[ -d /usr/share/sddm/themes/sddm-chili ]]; then
    sudo rm -rf /usr/share/sddm/themes/sddm-chili
  fi
  if [[ -d "${CONFIG_PATH}/hypr" ]]; then
    rm -rf "${CONFIG_PATH}/hypr"
  fi
  install_packages "${hyprland_packages[@]}" &&
  sudo systemctl enable sddm &&
  sudo mkdir -p /etc/sddm.conf.d &&
  sudo cp sddm/default.conf /etc/sddm.conf.d &&
  sudo cp sddm/wayland-session /usr/share/sddm/scripts/ &&
  git clone https://github.com/MarianArlt/sddm-chili.git  &&
  sudo cp sddm/theme.conf sddm-chili/theme.conf &&
  cp pictures/groot-dark.png sddm-chili/assets &&
  sudo mv sddm-chili /usr/share/sddm/themes &&
  git clone "${HIVERNAL}/hypr.git" "${CONFIG_PATH}/hypr"  &&
  cp -r .config/foot "${CONFIG_PATH}" &&
  cp .wprofile "${HOME}" &&
  cp scripts/grimblast "${HOME}/.local/bin"
}

install_themes() {
  install_packages "${themes_packages[@]}" &&
  git clone https://github.com/vinceliuice/Qogir-theme.git &&
  cd Qogir-theme &&
  sudo bash install.sh -d /usr/share/themes &&
  cd .. &&
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git &&
  cd Qogir-icon-theme &&
  sudo bash install.sh -d /usr/share/icons &&
  cd .. && rm -rf Qogir* &&
  font_path="${HOME}/.local/share/fonts/JetBrainsMono" &&
  mkdir -p "${font_path}" &&
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip &&
  unzip -d "${font_path}" JetBrainsMono.zip &&
  rm JetBrainsMono.zip
}

copy_files() {
  cp .bashrc .tmux.conf "${HOME}" &&
  cp pictures/* "${HOME}/pictures/" &&
  cp scripts/backup.sh "${HOME}/.local/bin" &&
  cp -r .config/mpv .config/mvi .config/systemd .config/user-dirs.dirs \
        .config/dunst .config/gtk-3.0 "${CONFIG_PATH}" &&
  cp scripts/run.sh "${HOME}/documents/qemu/" &&
  mkdir -p "${CONFIG_PATH}/nvim" &&
  cp -r .config/nvim_simple/* "${CONFIG_PATH}/nvim/" &&
  systemctl enable --user --now battery.timer
}

> "${LOG}"

mkdir -p "${HOME}/music" "${HOME}/desktop" "${HOME}/videos" \
         "${HOME}/templates" "${HOME}/downloads/git" \
         "${HOME}/downloads/iso" "${HOME}/downloads/browser" \
         "${HOME}/downloads/telegram" "${HOME}/pictures"
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/documents/qemu"
mkdir -p "${CONFIG_PATH}"

echo -en "1) install yay\n"
echo -en "2) install programs\n"
echo -en "3) install dwm\n"
echo -en "4) install hyprland\n"
echo -en "5) install alsa\n"
echo -en "6) install pipewire\n"
echo -en "7) install bluetooth\n"
echo -en "8) install themes and icons\n"
echo -en "9) install pandoc\n"
echo -en "10) Copy files\n"
echo -en "choose: "
read numbers
echo -en "\n"

for number in ${numbers}; do
  case ${number} in
    1)
      echo -en "Installing yay"
      if ! progress_wrapper install_yay; then
        echo -en "Failed to install yay\n"
        exit
      fi
      echo -en "Yay has been installed\n"
      ;;
    2)
      echo -en "Installing programs"
      if ! progress_wrapper install_packages "${programs[@]}"; then
        echo -en "Failed to install programs\n"
        exit
      fi
      echo -en "Programs has been installed\n"
      ;;
    3)
      echo -en "Installing dwm"
      if ! progress_wrapper install_dwm; then
        echo -en "Failed to install dwm\n"
        exit
      fi
      echo -en "Dwm has been installed\n"
      ;;
    4)
      echo -en "Installing hyprland packages"
      if ! progress_wrapper install_hyprland; then
        echo -en "Failed to install hyprland packages\n"
        exit
      fi
      echo -en "Hyprland packages has been installed\n"
      ;;
    5)
      echo -en "Installing alsa"
      if ! progress_wrapper install_packages "${alsa_packages[@]}"; then
        echo -en "Failed to install alsa\n"
        exit
      fi
      echo -en "Alsa has been installed\n"
      ;;
    6)
      echo -en "Installing pipewire"
      if ! progress_wrapper install_packages "${pipewire_packages[@]}"; then
        echo -en "Failed to install pipewire\n"
        exit
      fi
      echo -en "Pipewire has been installed\n"
      ;;
    7)
      echo -en "Installing bluetooth"
      if ! progress_wrapper install_packages "${bluetooth_packages[@]}"; then
        echo -en "Failed to install bluetooth\n"
        exit
      fi
      sudo systemctl enable bluetooth
      echo -en "Pipewire has been installed\n"
      ;;
    8)
      echo -en "Installing themes"
      if ! progress_wrapper install_themes; then
        echo -en "Failed to install themes\n"
        exit
      fi
      echo -en "Themes has been installed\n"
      ;;
    9)
      echo -en "Installing pandoc"
      if ! progress_wrapper install_packages "${pandoc_packages[@]}"; then
        echo -en "Failed to install pandoc\n"
        exit
      fi
      echo -en "Pandoc has been installed\n"
      ;;
    10)
      echo -en "Copying files\n"
      if ! copy_files; then
        echo -en "Failed to copy files\n"
        exit
      fi
      echo -en "Copying has been finished\n\n"
      ;;
  esac
done
