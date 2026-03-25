{
  systemd = {
    # Nuke faster
    user.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    services = {
      # Journal daemon hardening
      systemd-journald = {
        serviceConfig = {
          UMask = 0077;
          PrivateNetwork = true;
          ProtectHostname = true;
          ProtectKernelModules = true;
          ProtectProc = "invisible";
          PrivateMounts = true;
          NoNewPrivileges = true;
        };
      };

      # rfkill hardening
      systemd-rfkill = {
        serviceConfig = {
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };

      # Syslog hardening
      syslog = {
        serviceConfig = {
          PrivateNetwork = true;
          CapabilityBoundingSet = ["CAP_DAC_READ_SEARCH" "CAP_SYSLOG" "CAP_NET_BIND_SERVICE"];
          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          MemoryDenyWriteExecute = true;
          LockPersonality = true;
          ProtectKernelTunables = true;
          RestrictRealtime = true;
          PrivateUsers = true;
          PrivateTmp = true;
          UMask = "0077";
          RestrictNamespace = true;
          ProtectProc = "invisible";
          ProtectHome = true;
          DeviceAllow = false;
          ProtectSystem = "full";
        };
      };

      # Emergency daemon hardening
      emergency = {
        serviceConfig = {
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          IPAddressDeny = "any";
        };
      };

      # Harden getty
      "getty@tty1" = {
        serviceConfig = {
          PrivateNetwork = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          MemoryDenyWriteExecute = true;
          IPAddressDeny = "any";
        };
      };

      # More hardening
      reload-systemd-vconsole-setup = {
        serviceConfig = {
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          PrivateUsers = true;
          PrivateDevices = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          UMask = "0077";
          IPAddressDeny = "any";
        };
      };

      # Harden rescue daemon
      rescue = {
        serviceConfig = {
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          PrivateTmp = true;
          PrivateUsers = true;
          PrivateIPC = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          SystemCallFilter = ["write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom"];
          SystemCallArchitectures = "native";
          UMask = "0077";
        };
      };

      # Hardening v2
      "systemd-ask-password-console" = {
        serviceConfig = {
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          PrivateTmp = true;
          PrivateUsers = true;
          PrivateIPC = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictAddressFamilies = "AF_INET AF_INET6";
          RestrictNamespaces = true;
          SystemCallFilter = ["@system-service"];
          SystemCallArchitectures = "native";
          UMask = "0077";
          IPAddressDeny = "any";
        };
      };

      # Hardening v3
      "systemd-ask-password-wall" = {
        serviceConfig = {
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          PrivateTmp = true;
          PrivateUsers = true;
          PrivateDevices = true;
          PrivateIPC = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictAddressFamilies = "AF_INET AF_INET6";
          RestrictNamespaces = true;
          SystemCallFilter = ["@system-service"];
          SystemCallArchitectures = "native";
          UMask = "0077";
          IPAddressDeny = "any";
        };
      };
    };
  };
}
