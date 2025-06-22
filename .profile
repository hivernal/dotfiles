export LANG="en_US.UTF-8"
export LC_COLLATE="C.UTF-8"

export XDG_CACHE_HOME="/run/user/${UID}/cache"

# export AMD_VULKAN_ICD=AMDVLK
export WINE="${HOME}/downloads/git/wine-ntsync/bin/wine"

export MANPAGER='nvim +Man!'
# export MANWIDTH=999

# export MANROFFOPT="-c"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export BAT_PAGER="less -RFXSM +Gg"
# export BAT_THEME="tokyonight_night"

export PATH="${PATH}:${HOME}/.local/bin"
export QT_QPA_PLATFORMTHEME=qt6ct
# export GTK_THEME=Qogir-Dark

export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"

export NNN_BMS="p:~/documents/projects;d:~/downloads;c:~/.config;q:~/documents/qemu;o:~/documents/office;h:~;/:/;l:~/.local"
export NNN_PLUG="o:fzopen;x:!chmod +x ${nnn};c:fzcd;s:suedit"
export NNN_OPTS="AaioeEU"

export FZF_DEFAULT_OPTS="--height 40% \
                         --color=fg:#d2d9f8,bg:#1a1b26,hl:#ff9e64 \
                         --color=fg+:#d2d9f8,bg+:#292e42,hl+:#ff9e64 \
                         --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
                         --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a \
                         --bind=tab:down,btab:up,ctrl-a:toggle"

export BEMENU_OPTS='-p ">" -n -H 26 --fn "JetBrainsMono NF Medium 11" --tb #1a1b26 --tf #d2d9f8 --fb #1a1b26 --ff #d2d9f8 --nf #d2d9f8 --nb #1a1b26 --hf #d2d9f8 --hb #5e5f67 --sb #1a1b26 --sf #d2d9f8 --af #d2d9f8 --ab #1a1b26' # TokyoNight

# export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
