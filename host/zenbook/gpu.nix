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
    powerManagement.enable = false; # https://forums.developer.nvidia.com/t/fixed-suspend-resume-issues-with-the-driver-version-470/187150/3
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    dynamicBoost.enable = false; # nvidia-powerd, should make changes only on AC
    videoAcceleration = true; # vaapi nvidia

    prime = {
      nvidiaBusId = "PCI:1:0:0"; # pci@0000:01:00.0 nvidia
      intelBusId = "PCI:0:2:0"; # pci@0000:00:02.0 intel

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  boot.kernelParams = lib.mkAfter [
    "nvidia.NVreg_DynamicPowerManagementVideoMemoryThreshold=1024"
    # "nvidia.NVreg_S0ixPowerManagementVideoMemoryThreshold=1024"
    # "nvidia.NVreg_EnableS0ixPowerManagement=1"
    # "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    # "nvidia.NVreg_EnableGpuFirmware=0"
    "nvidia.NVreg_DynamicPowerManagement=0x03"
    # "nvidia.NVreg_UsePageAttributeTable=1"
    # "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
    "nvidia-drm.fbdev=0"
    "initcall_blacklist=sysfb_init"
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

  # Change prime mode and some hyprland env vars (hdmi doesn't work with offload)
  specialisation.multi-monitor.configuration = {
    home-manager.users.samu.wayland.windowManager.hyprland.settings.env = [
      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "NVD_BACKEND,direct"
    ];
    hardware.nvidia = {
      prime.offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
      # prime.sync.enable = lib.mkForce true;
      powerManagement.finegrained = lib.mkForce false;
    };
    environment.sessionVariables = let name = config.users.default.name; in {
      AQ_DRM_DEVICES = lib.mkForce "/home/${name}/.config/hypr/intel:/home/${name}/.config/hypr/nvidia";
      GSK_RENDERER = lib.mkForce null;
      __EGL_VENDOR_LIBRARY_FILENAMES = lib.mkForce null;
    };
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  # Use these or the standard nvidia settings (not working now)
  services.supergfxd.enable = false;

  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/home/${config.users.default.name}/.config/hypr/intel"; # no nvidia, it keeps an open fd on the card anyway
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
    # Don't use vulkan on GTK, avoid GPU wake
    GSK_RENDERER =  "ngl";
  };
  home-manager.users.samu.systemd.user.services.swaync.Service.Environment = [ "GSK_RENDERER=ngl" ];
}
