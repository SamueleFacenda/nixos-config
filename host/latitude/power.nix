{ config, pkgs, lib, ... }: {
  # Hardware tweaks (from https://nixos.wiki/wiki/Laptop)
  
  services.journald.extraConfig = ''
    ReadKMsg=no
    SyncIntervalSec=60m

  '';
  # SystemMaxUse=50M
  # SystemMaxFileSize=10M
  
  environment.etc."default/laptop-mode".text = ''
    MAX_AGE=30000
    MINIMUM_BATTERY_MINUTES=0
    AC_HD=24
    HD=/dev/sda
    DIRTY_RATIO=50
    DIRTY_BACKGROUND_RATIO=5
  '';
  
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "sda";
      DISK_APM_LEVEL_ON_AC = "18"; # 1 for max power saving
      DISK_APM_LEVEL_ON_BAT = "128"; # 1
      DISK_SPINDOWN_TIMEOUT_ON_AC = "24";
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "24";
      # SATA_LINKPWR_ON_AC = "min_power":
      # SATA_LINKPWR_ON_BAT = "min_power":
      AHCI_RUNTIME_PM_ON_AC = "auto";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      
      DISK_IDLE_SECS_ON_AC = 2;
      
      MAX_LOST_WORK_SECS_ON_AC = "30000";
      MAX_LOST_WORK_SECS_ON_BAT = "30000";

      PLATFORM_PROFILE_ON_AC = "low-power";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      PCIE_ASPM_ON_AC = "powersave";
      PCIE_ASPM_ON_BAT = "powersave"; # or powersupersave

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_PHONE = 1;
      USB_EXCLUDE_BTUSB = 1;
    };
  };

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
      charger = {
        governor = "powersave";
        energy_performance_preference = "powers";
        turbo = "auto";
      };
    };
  };

  powerManagement.powertop.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    powertop
  ];
}
