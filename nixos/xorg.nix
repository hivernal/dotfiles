{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = false;
    videoDrivers = [ "modesetting" ];
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = ./dwm;
      };
    };
    displayManager.startx.enable = true;
    autoRepeatInterval = 25;
    autoRepeatDelay = 300;
    xkb = {
      layout = "us,ru";
      variant = ",";
      options = "grp:win_space_toggle";
    };
  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      accelSpeed = "0.3";
    };
  };
}
