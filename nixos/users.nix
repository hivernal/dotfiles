{ config, lib, pkgs, ... }:

{
  users.users.nikita = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      git
      bash-completion
      (dmenu.overrideAttrs (oldAttrs: rec {
        configFile = writeText "config.def.h" (builtins.readFile /home/nikita/.config/dmenu/config.def.h);
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      }))
      (st.overrideAttrs (oldAttrs: rec {
        configFile = writeText "config.def.h" (builtins.readFile /home/nikita/.config/st/config.def.h);
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      }))
      tmux
      (slstatus.overrideAttrs (oldAttrs: rec {
        configFile = writeText "config.def.h" (builtins.readFile /home/nikita/.config/slstatus/config.def.h);
        postPatch = "cp ${configFile} config.def.h";
      }))
      xclip
      xdg-user-dirs
      brightnessctl
      dunst
      feh
      fd
      fzf
      htop
      ripgrep
      flameshot
      zip
      unzip
      mpv
      yt-dlp
      lxappearance
      neovim
      telegram-desktop
    ];
  };
}
