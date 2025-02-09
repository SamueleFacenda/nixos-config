{ config, pkgs, lib, ... }: {

  # Nvidia (https://wiki.nixos.org/wiki/Nvidia)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement.enable = false; # https://forums.developer.nvidia.com/t/fixed-suspend-resume-issues-with-the-driver-version-470/187150/3
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    dynamicBoost.enable = true; # nvidia-powerd, should make changes only on AC
    videoAcceleration = true; # vaapi nvidia

    prime = {
      # pci@0000:00:02.0 intel
      # pci@0000:01:00.0 nvidia
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  
  boot.kernelParams = [
    "nvidia.NVreg_TemporaryFilePath=/var/tmp"
  ];

  # Change prime mode and some hyprland env vars (hdmi doesn't work with offload)
  specialisation.multi-monitor.configuration = {
    home-manager.users.samu.wayland.windowManager.hyprland.settings.env = [
      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      "LIBVA_DRIVER_NAME,nvidia"
      # "XDG_SESSION_TYPE,wayland"
      # "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "NVD_BACKEND,direct"
      # "WLR_NO_HARDWARE_CURSORS,1"
    ];
    hardware.nvidia = {
      prime.offload = {
        enable = lib.mkForce false;
        enableOffloadCmd = lib.mkForce false;
      };
      # prime.sync.enable = lib.mkForce true;
      powerManagement.finegrained = lib.mkForce false;
    };
    environment.sessionVariables.AQ_DRM_DEVICES = lib.mkForce 
      "/home/${config.users.default.name}/.config/hypr/intel:/home/${config.users.default.name}/.config/hypr/nvidia";
  };

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];

  # Use these or the standard nvidia settings (not working now)
  services.supergfxd.enable = false;
  
  # environment.sessionVariables.AQ_DRM_DEVICES = "/home/${config.users.default.name}/.config/hypr/intel:/home/${config.users.default.name}/.config/hypr/nvidia";
  environment.sessionVariables.AQ_DRM_DEVICES = "/home/${config.users.default.name}/.config/hypr/intel";
}
