{ config, pkgs, lib, ... }: {

  # Nvidia (https://wiki.nixos.org/wiki/Nvidia)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement = {
      enable = true; # https://forums.developer.nvidia.com/t/fixed-suspend-resume-issues-with-the-driver-version-470/187150/3
      finegrained = true;
      kernelSuspendNotifier = true;
    };
    open = true;
    nvidiaSettings = true;
    dynamicBoost.enable = true; # nvidia-powerd, should make changes only on AC
    videoAcceleration = true; # vaapi nvidia

    prime = {
      nvidiaBusId = "PCI:1:0:0"; # pci@0000:01:00.0 nvidia
      intelBusId = "PCI:0:2:0"; # pci@0000:00:02.0 intel

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
    moduleParams.nvidia = {
      NVreg_DynamicPowerManagementVideoMemoryThreshold = 1024;
      # NVreg_TemporaryFilePath = "/var/tmp";
      NVreg_PreserveVideoMemoryAllocations = lib.mkForce 0;
    };
  };

  boot.kernelParams = lib.mkAfter [
    # "nvidia.NVreg_S0ixPowerManagementVideoMemoryThreshold=1024"
    # "nvidia.NVreg_EnableS0ixPowerManagement=1"
    # "nvidia.NVreg_EnableGpuFirmware=0"
    # "nvidia.NVreg_UseKernelSuspendNotifiers=1"
    # "nvidia.NVreg_DynamicPowerManagement=0x03" finegrained
    # "nvidia.NVreg_UsePageAttributeTable=1"
    # "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
    # "nvidia-drm.fbdev=0"
    # "initcall_blacklist=sysfb_init"
  ];
  
  services.udev.extraRules = lib.optionalString config.hardware.nvidia.powerManagement.finegrained ''
    # Enable runtime PM for NVIDIA audio controller devices on driver bind
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", TEST=="power/control", ATTR{power/control}="auto"
    # Disable runtime PM for NVIDIA audio controller devices on driver unbind
    ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", TEST=="power/control", ATTR{power/control}="on"
    
    # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
    ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
  '';

  # Change prime mode and some hyprland env vars (hdmi doesn't work with offload). Update, it does on normal config as long as I don't suspend
  specialisation.multi-monitor.configuration = {
    home-manager.users.samu.wayland.windowManager.hyprland.settings.env = [
      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      { _args = [ "LIBVA_DRIVER_NAME" "nvidia" ]; }
      { _args = [ "__GLX_VENDOR_LIBRARY_NAME" "nvidia" ]; }
      { _args = [ "NVD_BACKEND" "direct" ]; }
    ];
    hardware.nvidia = {
      prime.offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
      # prime.sync.enable = lib.mkForce true;
      powerManagement.finegrained = lib.mkForce false;
    };
    environment.sessionVariables.GSK_RENDERER = lib.mkForce null;
  };

  environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];

  environment.sessionVariables = let name = config.users.default.name; in {
    AQ_DRM_DEVICES = "/home/${name}/.config/hypr/intel:/home/${name}/.config/hypr/nvidia";
    # Don't use vulkan on GTK, avoid GPU wake
    GSK_RENDERER =  "ngl";
  };
  home-manager.users.samu.systemd.user.services.swaync.Service.Environment = [ "GSK_RENDERER=ngl" ];
  home-manager.users.samu.systemd.user.services.swayosd.Service.Environment = [ "GSK_RENDERER=ngl" ];
}
