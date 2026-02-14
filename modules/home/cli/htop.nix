{config, ...}: {
  programs.htop = {
    enable = true;
    settings =
      {
        color_scheme = 6;
        cpu_count_from_one = 0;
        delay = 15;
        fields = [
          config.lib.htop.fields.PID
          config.lib.htop.fields.USER
          config.lib.htop.fields.PRIORITY
          config.lib.htop.fields.NICE
          config.lib.htop.fields.M_SIZE
          config.lib.htop.fields.M_RESIDENT
          config.lib.htop.fields.M_SHARE
          config.lib.htop.fields.STATE
          config.lib.htop.fields.PERCENT_CPU
          config.lib.htop.fields.PERCENT_MEM
          config.lib.htop.fields.TIME
          config.lib.htop.fields.COMM
        ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
      }
      // (
        config.lib.htop.leftMeters [
          (config.lib.htop.bar "AllCPUs2")
          (config.lib.htop.bar "Memory")
          (config.lib.htop.bar "Swap")
          (config.lib.htop.text "Zram")
        ]
      )
      // (
        config.lib.htop.rightMeters [
          (config.lib.htop.text "Tasks")
          (config.lib.htop.text "LoadAverage")
          (config.lib.htop.text "Uptime")
          (config.lib.htop.text "Systemd")
        ]
      );
  };
}
