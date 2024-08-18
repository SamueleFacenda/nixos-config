{ config, pkgs, lib, ... }: {
  # Hardware tweaks (from https://nixos.wiki/wiki/Laptop)

  services.thermald.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      # DISK_DEVICES = "nvme0n1";
      # DISK_APM_LEVEL_ON_AC = "254";
      # DISK_APM_LEVEL_ON_BAT = "128";
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      RESTORE_DEVICE_STATE_ON_STARTUP = 0;
      DEVICES_TO_ENABLE_ON_AC = "bluetooth wifi";
      DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth wifi";
      USB_EXCLUDE_BTUSB = 1; # "8087:0033";

      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # RUNTIME_PM_DRIVER_DENYLIST = "thunderbolt nvidia";
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersave"; # or powersupersave

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_PHONE = 1;

      # Optional helps save long term battery health
      # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 75; # 80 and above it stops charging

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
        governor = "performance";
        energy_performance_preference = "performance";
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
