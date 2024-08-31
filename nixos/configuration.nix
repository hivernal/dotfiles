{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ./network.nix
    ./xorg.nix
    ./tlp.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
    libvdpau-va-gl
  ];
  hardware.opengl.driSupport = true;

  time.timeZone = "Asia/Krasnoyarsk";

#   i18n.defaultLocale = "en_US.UTF-8";
#   console = {
#     font = "Lat2-Terminus32";
#     keyMap = "us";
#     useXkbConfig = true; # use xkb.options in tty.
#   };

  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  nixpkgs.overlays = [ (import ./overlays.nix) ];

  environment.systemPackages = with pkgs; [
    vim
    # firefox
    chromium
    qogir-theme
    qogir-icon-theme
    # qemu
    # virt-viewer
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = "24.05"; # Did you read the comment?
}
