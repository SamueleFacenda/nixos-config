self: super: {
  surface-control = super.surface-control.overrideAttrs (finalAttrs: previousAttrs: {
    version = "${previousAttrs.version}-patched";

    postPatch = ''
      targetFile="etc/udev/40-surface-control.rules"
      echo 'ACTION=="add", KERNEL=="acpi", RUN+="${super.coreutils}/bin/chmod 664 /sys/firmware/acpi/platform_profile"' > $targetFile
      echo 'ACTION=="add", KERNEL=="acpi", RUN+="${super.coreutils}/bin/chgrp surface-control /sys/firmware/acpi/platform_profile"' >> $targetFile
    '';
  });
}
