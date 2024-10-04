{ config, pkgs, lib, ... }: {
  # Hardware tweaks (from https://nixos.wiki/wiki/Laptop)

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      DISK_DEVICES = "sda";
      DISK_APM_LEVEL_ON_AC = "18"; # 1 for max power saving
      DISK_APM_LEVEL_ON_BAT = "128"; # 1
      DISK_SPINDOWN_TIMEOUT_ON_AC = "3";
      DISK_SPINDOWN_TIMEOUT_ON_BAT = "3";
      # SATA_LINKPWR_ON_AC = "min_power":
      # SATA_LINKPWR_ON_BAT = "min_power":
      AHCI_RUNTIME_PM_ON_AC = "auto";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      
      MAX_LOST_WORK_SECS_ON_AC = "100";
      MAX_LOST_WORK_SECS_ON_BAT = "100";

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
