#!/bin/bash

pipewire_packages=(
  alsa-utils
  alsa-tools
  wireplumber
  pipewire
  pipewire-audio
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
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

programs=(
  pipewire-jack
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
  unrar
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
  ttf-times-new-roman
  "${themes_packages[@]}"
)

wm_packages=(
  tmux
  kvantum
  dunst
  libnotify
  imv
  mpv
  brightnessctl
  nm-connection-editor
)

hyprland_packages=(
  pipewire-jack
  hyprland
  xdg-desktop-portal-hyprland
  waybar
  bemenu-wayland
  foot
  swaybg
  grim
  slurp
  jq
  wl-clipboard
  sddm-git
  nwg-look-bin
  qt5-wayland
  qt6-wayland
  qt5-quickcontrols
  qt5-graphicaleffects
  "${wm_packages[@]}"
)

xorg_packages=(
  pipewire-jack
  meson
  ninja
  mesa
  xorgproto
  xtrans
  pixman
  libxkbfile
  libxfont2
  libxcvt
  libepoxy
  xorg-xkbcomp
  xf86-input-libinput
)

dwm_packages=(
  pipewire-jack
  xorg-xinit
  mesa
  feh
  vulkan-intel
  intel-media-driver
  libva-vdpau-driver
  libvdpau-va-gl
  flameshot
  xclip
  lxappearance-gtk3
  "${wm_packages[@]}"
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

install_xorg() {
  install_packages "${xorg_packages[@]}" &&
  git clone https://gitlab.freedesktop.org/xorg/xserver.git &&
  cd xserver &&
  meson setup --prefix /usr build \
    -D ipv6=true \
    -D xvfb=true \
    -D xnest=true \
    -D xcsecurity=true \
    -D xorg=true \
    -D xephyr=true \
    -D glamor=true \
    -D udev=true \
    -D dtrace=false \
    -D systemd_logind=true \
    -D suid_wrapper=true \
    -D xkb_dir=/usr/share/X11/xkb \
    -D xkb_output_dir=/var/lib/xkb \
    -D libunwind=true &&

  sudo meson install -C build &&
  cd .. && rm -rf xserver &&
  sudo mkdir -p /usr/share/X11/xorg.conf.d &&
  sudo cp -r xorg.conf.d/* /etc/X11/xorg.conf.d/
}

install_dwm() {
  dwm_path="${CONFIG_PATH}/dwm"
  if [[ -d "${dwm_path}" ]]; then
    rm -rf "${dwm_path}"
  fi
  install_xorg &&
  install_packages "${dwm_packages[@]}" &&
  cp .xinitrc "${HOME}" &&
  cp .xprofile "${HOME}" &&
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
  font_path="${HOME}/.local/share/fonts/JetBrainsMono"
  if [[ -d "${font_path}" ]]; then
    rm -rf "${font_path}"
  fi
  install_packages "${themes_packages[@]}" &&
  git clone https://github.com/vinceliuice/Qogir-theme.git &&
  cd Qogir-theme &&
  sudo bash install.sh -d /usr/share/themes &&
  cd .. &&
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git &&
  cd Qogir-icon-theme &&
  sudo bash install.sh -d /usr/share/icons &&
  cd .. && rm -rf Qogir* &&
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
echo -en "5) install pipewire and bluetooth\n"
echo -en "6) install themes and icons\n"
echo -en "7) install pandoc\n"
echo -en "8) Copy files\n"
echo -en "choose: "
read numbers
echo -en "\n"

for number in ${numbers}; do
  case ${number} in
    1)
      echo -en "Installing yay"
      if ! progress_wrapper install_yay; then
        echo -en "Failed to install yay. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Yay has been installed\n"
      ;;
    2)
      echo -en "Installing programs"
      if ! progress_wrapper install_packages "${programs[@]}"; then
        echo -en "Failed to install programs. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Programs has been installed\n"
      ;;
    3)
      echo -en "Installing dwm"
      if ! progress_wrapper install_dwm; then
        echo -en "Failed to install dwm. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Dwm has been installed\n"
      ;;
    4)
      echo -en "Installing hyprland packages"
      if ! progress_wrapper install_hyprland; then
        echo -en "Failed to install hyprland packages. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Hyprland packages has been installed\n"
      ;;
    5)
      echo -en "Installing pipewire and bluetooth"
      if ! progress_wrapper install_packages "${pipewire_packages[@]}"; then
        echo -en "Failed to install pipewire and bluetooth. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Pipewire and bluetooth have been installed\n"
      ;;
    6)
      echo -en "Installing themes"
      if ! progress_wrapper install_themes; then
        echo -en "Failed to install themes. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Themes has been installed\n"
      ;;
    7)
      echo -en "Installing pandoc"
      if ! progress_wrapper install_packages "${pandoc_packages[@]}"; then
        echo -en "Failed to install pandoc. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Pandoc has been installed\n"
      ;;
    8)
      echo -en "Copying files\n"
      if ! copy_files; then
        echo -en "Failed to copy files. Check ${PWD}/${LOG}\n"
        exit
      fi
      echo -en "Copying has been finished\n\n"
      ;;
  esac
done
