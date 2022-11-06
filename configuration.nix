
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "dell"; # Define your hostname.
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Plasma Desktop Environment.
     services.xserver.displayManager.lightdm = {
        enable = true;
        background = "/etc/lightdm/punch.jpg";
           #icon = "/etc/lightdm/board.png";
            greeters.gtk = {
               # theme.package = pkgs.xfce.xfwm4-themes;
               theme.package = pkgs.zuki-themes;
               #theme.name = "Adwaiata-dark";                          
               theme.name = "Zukitwo-dark";
      };
};  
     services.xserver.desktopManager.xfce.enable = true;

  # Enable gnome keyring
     services.gnome.gnome-keyring.enable = true;
     security.pam.services.login.enableGnomeKeyring = true; 

 # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # Low-latency setup https://nixos.wiki/wiki/PipeWire
    config.pipewire = {
   "context.properties" = {
    "link.max-buffers" = 1024;
   "log.level" = 2;
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 512;
      "default.clock.min-quantum" = 256;
      "default.clock.max-quantum" = 1024;
      "core.daemon" = true;
      "core.name" = "pipewire-0";
    };
    "context.modules" = [
      {
        name = "libpipewire-module-rtkit";
        args = {
          "nice.level" = -15;
          "rt.prio" = 88;
          "rt.time.soft" = 200000;
          "rt.time.hard" = 200000;
        };
        flags = [ "ifexists" "nofail" ];
      }
      { name = "libpipewire-module-protocol-native"; }
      { name = "libpipewire-module-profiler"; }
      { name = "libpipewire-module-metadata"; }
      { name = "libpipewire-module-spa-device-factory"; }
      { name = "libpipewire-module-spa-node-factory"; }
      { name = "libpipewire-module-client-node"; }
      { name = "libpipewire-module-client-device"; }
      {
        name = "libpipewire-module-portal";
        flags = [ "ifexists" "nofail" ];
      }
      {
        name = "libpipewire-module-access";
        args = {};
      }
      { name = "libpipewire-module-adapter"; }
      { name = "libpipewire-module-link-factory"; }
      { name = "libpipewire-module-session-manager"; }
   ];
  };
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.xserver.libinput.enable = true;

  # Enable flatpak
  # services.flatpak.enable = true; 
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paulos = {
    isNormalUser = true;
    description = "paulos";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      
      # kate
      # Internet
      firefox
      brave
      thunderbird
      okular
      # Escritorio
      libreoffice
      vscode
      unzip
      direnv
      # Audio
      helvum
      pnmixer
      pavucontrol
      # Video
      obs-studio
      vlc
      libsForQt5.kdenlive
      gphoto2
        
      
       
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #NVIDIA config in nixos.wiki

#  services.xserver.videoDrivers = [ "nvidia" ];
#  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
# hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xz
    gzip
    vim
    htop
    neofetch
    ffmpeg
    xfce.catfish
    xfce.xfce4-whiskermenu-plugin 
    xfce.xfce4-clipman-plugin   
    xfce.thunar-archive-plugin
    dropbox-cli
    unzip
    p7zip
    xarchiver
    xfce.thunar-dropbox-plugin   
    lightdm_gtk_greeter    
    maia-icon-theme
    gparted
    libsForQt5.breeze-icons
    zafiro-icons
#    etcher
];
   security.pam.services.gdm.enableGnomeKeyring = true;

  # Make some extra kernel modules available to NixOS (configuracao para camera DSRL, importante q tenho ffmpg já isntalado)
  boot.extraModulePackages = with config.boot.kernelPackages;
    [ v4l2loopback.out ];

  # Activate kernel modules (choose from built-ins and extra ones)
  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
  
  ];

  # Set initial kernel module settings
  boot.extraModprobeConfig = ''
    # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
    # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 max_buffers=2 card_label="Canon"
  '';
  # Musnix configs
  

 # Real time audio configs (tentei ser resumido e fazer as configurações do site do jack apenas)

    powerManagement.cpuFreqGovernor = "performance";

    #fileSystems."/" = { options = "noatime errors=remount-ro"; };

    security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
