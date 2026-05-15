{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.calagopus-wings;
  yamlFmt = pkgs.formats.yaml {};

  # Generate YAML config template with env-var placeholders for secrets
  configYaml = yamlFmt.generate "wings-config.yml" {
    debug = cfg.debug;
    app_name = cfg.appName;
    uuid = cfg.uuid;
    token_id = "\${WINGS_TOKEN_ID}";
    token = "\${WINGS_TOKEN}";
    remote = "\${WINGS_REMOTE}";
    remote_headers = cfg.remoteHeaders;
    ignore_panel_config_updates = cfg.ignorePanelConfigUpdates;
    ignore_panel_wings_upgrades = cfg.ignorePanelWingsUpgrades;
    allowed_mounts = cfg.allowedMounts;
    allowed_origins = cfg.allowedOrigins;
    allow_cors_private_network = cfg.allowCorsPrivateNetwork;

    api = {
      host = cfg.api.host;
      port = cfg.api.port;
      ssl = {
        enabled = cfg.api.ssl.enable;
        cert = cfg.api.ssl.cert;
        key = cfg.api.ssl.key;
      };
      redirects = cfg.api.redirects;
      disable_openapi_docs = cfg.api.disableOpenapiDocs;
      disable_remote_download = cfg.api.disableRemoteDownload;
      server_remote_download_limit = cfg.api.serverRemoteDownloadLimit;
      remote_download_blocked_cidrs = cfg.api.remoteDownloadBlockedCidrs;
      disable_directory_size = cfg.api.disableDirectorySize;
      directory_entry_limit = cfg.api.directoryEntryLimit;
      send_offline_server_logs = cfg.api.sendOfflineServerLogs;
      file_search_threads = cfg.api.fileSearchThreads;
      file_copy_threads = cfg.api.fileCopyThreads;
      file_decompression_threads = cfg.api.fileDecompressionThreads;
      file_compression_threads = cfg.api.fileCompressionThreads;
      upload_limit = cfg.api.uploadLimit;
      max_jwt_uses = cfg.api.maxJwtUses;
      trusted_proxies = cfg.api.trustedProxies;
    };

    system = {
      root_directory = cfg.system.rootDirectory;
      log_directory = cfg.system.logDirectory;
      vmount_directory = cfg.system.vmountDirectory;
      data = cfg.system.data;
      archive_directory = cfg.system.archiveDirectory;
      backup_directory = cfg.system.backupDirectory;
      tmp_directory = cfg.system.tmpDirectory;
      username = cfg.system.username;
      timezone = cfg.system.timezone;
      user = {
        rootless = {
          enabled = cfg.system.user.rootless.enable;
          container_uid = cfg.system.user.rootless.containerUid;
          container_gid = cfg.system.user.rootless.containerGid;
        };
        uid = cfg.system.user.uid;
        gid = cfg.system.user.gid;
      };
      passwd = {
        enabled = cfg.system.passwd.enable;
        directory = cfg.system.passwd.directory;
      };
      machine_id = {
        enabled = cfg.system.machineId.enable;
      };
      disk_check_concurrency = cfg.system.diskCheckConcurrency;
      disk_check_interval = cfg.system.diskCheckInterval;
      full_disk_check_every = cfg.system.fullDiskCheckEvery;
      disk_check_use_inotify = cfg.system.diskCheckUseInotify;
      disk_limiter_mode = cfg.system.diskLimiterMode;
      activity_send_interval = cfg.system.activitySendInterval;
      activity_send_count = cfg.system.activitySendCount;
      check_permissions_on_boot = cfg.system.checkPermissionsOnBoot;
      check_permissions_on_boot_threads = cfg.system.checkPermissionsOnBootThreads;
      websocket_log_count = cfg.system.websocketLogCount;

      sftp = {
        enabled = cfg.system.sftp.enable;
        bind_address = cfg.system.sftp.bindAddress;
        bind_port = cfg.system.sftp.bindPort;
        read_only = cfg.system.sftp.readOnly;
        key_algorithm = cfg.system.sftp.keyAlgorithm;
        disable_password_auth = cfg.system.sftp.disablePasswordAuth;
        directory_entry_limit = cfg.system.sftp.directoryEntryLimit;
        directory_entry_send_amount = cfg.system.sftp.directoryEntrySendAmount;
        limits = {
          authentication_password_attempts = cfg.system.sftp.limits.authenticationPasswordAttempts;
          authentication_pubkey_attempts = cfg.system.sftp.limits.authenticationPubkeyAttempts;
          authentication_cooldown = cfg.system.sftp.limits.authenticationCooldown;
        };
        shell = {
          enabled = cfg.system.sftp.shell.enable;
          cli = {
            name = cfg.system.sftp.shell.cli.name;
          };
        };
        activity = {
          log_logins = cfg.system.sftp.activity.logLogins;
          log_file_reads = cfg.system.sftp.activity.logFileReads;
        };
      };

      crash_detection = {
        enabled = cfg.system.crashDetection.enable;
        detect_clean_exit_as_crash = cfg.system.crashDetection.detectCleanExitAsCrash;
        timeout = cfg.system.crashDetection.timeout;
      };

      file_history = {
        enabled = cfg.system.fileHistory.enable;
        zstd_level = cfg.system.fileHistory.zstdLevel;
        anchor_interval = cfg.system.fileHistory.anchorInterval;
        keep_chains = cfg.system.fileHistory.keepChains;
        file_size_cap = cfg.system.fileHistory.fileSizeCap;
        per_file_size_cap = cfg.system.fileHistory.perFileSizeCap;
        per_file_disk_budget = cfg.system.fileHistory.perFileDiskBudget;
        per_server_disk_budget = cfg.system.fileHistory.perServerDiskBudget;
        maintenance_interval = cfg.system.fileHistory.maintenanceInterval;
      };

      backups = {
        write_limit = cfg.system.backups.writeLimit;
        read_limit = cfg.system.backups.readLimit;
        compression_level = cfg.system.backups.compressionLevel;
        mounting = {
          enabled = cfg.system.backups.mounting.enable;
          path = cfg.system.backups.mounting.path;
        };
        wings = {
          create_threads = cfg.system.backups.wings.createThreads;
          restore_threads = cfg.system.backups.wings.restoreThreads;
          archive_format = cfg.system.backups.wings.archiveFormat;
        };
        s3 = {
          create_threads = cfg.system.backups.s3.createThreads;
          part_upload_timeout = cfg.system.backups.s3.partUploadTimeout;
          retry_limit = cfg.system.backups.s3.retryLimit;
        };
        ddup_bak = {
          create_threads = cfg.system.backups.ddupBak.createThreads;
          compression_format = cfg.system.backups.ddupBak.compressionFormat;
        };
        restic = {
          repository = cfg.system.backups.restic.repository;
          password_file = cfg.system.backups.restic.passwordFile;
          retry_lock_seconds = cfg.system.backups.restic.retryLockSeconds;
          environment = cfg.system.backups.restic.environment;
        };
        btrfs = {
          restore_threads = cfg.system.backups.btrfs.restoreThreads;
          create_read_only = cfg.system.backups.btrfs.createReadOnly;
        };
        zfs = {
          restore_threads = cfg.system.backups.zfs.restoreThreads;
        };
      };

      transfers = {
        download_limit = cfg.system.transfers.downloadLimit;
      };
    };

    docker = {
      socket = cfg.docker.socket;
      server_name_in_container_name = cfg.docker.serverNameInContainerName;
      delete_container_on_stop = cfg.docker.deleteContainerOnStop;
      network = {
        interface = cfg.docker.network.interface;
        disable_interface_binding = cfg.docker.network.disableInterfaceBinding;
        dns = cfg.docker.network.dns;
        name = cfg.docker.network.name;
        ispn = cfg.docker.network.ispn;
        driver = cfg.docker.network.driver;
        mode = cfg.docker.network.mode;
        is_internal = cfg.docker.network.isInternal;
        enable_icc = cfg.docker.network.enableIcc;
        network_mtu = cfg.docker.network.networkMtu;
        interfaces = {
          v4 = {
            subnet = cfg.docker.network.interfaces.v4.subnet;
            gateway = cfg.docker.network.interfaces.v4.gateway;
          };
          v6 = {
            subnet = cfg.docker.network.interfaces.v6.subnet;
            gateway = cfg.docker.network.interfaces.v6.gateway;
          };
        };
      };
      domainname = cfg.docker.domainname;
      registries = cfg.docker.registries;
      tmpfs_size = cfg.docker.tmpfsSize;
      container_pid_limit = cfg.docker.containerPidLimit;
      installer_limits = {
        timeout = cfg.docker.installerLimits.timeout;
        memory = cfg.docker.installerLimits.memory;
        cpu = cfg.docker.installerLimits.cpu;
      };
      overhead = {
        override = cfg.docker.overhead.override;
        default_multiplier = cfg.docker.overhead.defaultMultiplier;
        multipliers = cfg.docker.overhead.multipliers;
      };
      userns_mode = cfg.docker.usernsMode;
      log_config = {
        type = cfg.docker.logConfig.type;
        config = cfg.docker.logConfig.config;
      };
    };

    throttles = {
      enabled = cfg.throttles.enable;
      lines = cfg.throttles.lines;
      line_reset_interval = cfg.throttles.lineResetInterval;
    };

    remote_query = {
      timeout = cfg.remoteQuery.timeout;
      boot_servers_per_page = cfg.remoteQuery.bootServersPerPage;
      retry_limit = cfg.remoteQuery.retryLimit;
    };
  };
in {
  options.services.calagopus-wings = {
    enable = lib.mkEnableOption "Calagopus Wings Daemon";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wings;
      description = "The Wings package to use. Override with pkgs.wings-nightly for nightly builds.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing secret environment variables.
        Must define: WINGS_TOKEN_ID, WINGS_TOKEN, WINGS_REMOTE (panel URL).
        These are substituted into the generated YAML config at runtime via envsubst.
      '';
    };

    # ---- top-level options ----

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug-level logging.";
    };

    appName = lib.mkOption {
      type = lib.types.str;
      default = "Pterodactyl";
      description = "Display name for the daemon.";
    };

    uuid = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Unique identifier for this Wings instance. Auto-generated if empty.";
    };

    remoteHeaders = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Custom HTTP headers for panel API calls.";
    };

    ignorePanelConfigUpdates = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip config updates pushed from the panel.";
    };

    ignorePanelWingsUpgrades = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Skip upgrade notifications from the panel.";
    };

    allowedMounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Allowed server mount paths.";
    };

    allowedOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Allowed CORS origins. Use \"*\" for all.";
    };

    allowCorsPrivateNetwork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow CORS private network access.";
    };

    # ---- api section ----

    api = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "API bind address (IP or Unix socket path).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "HTTP/HTTPS listen port.";
      };

      ssl = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable HTTPS for the API.";
        };

        cert = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Path to SSL certificate file (PEM).";
        };

        key = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Path to SSL key file (PEM).";
        };
      };

      redirects = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "URL path → redirect target mappings.";
      };

      disableOpenapiDocs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable the /openapi.json endpoint.";
      };

      disableRemoteDownload = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable remote URL downloads.";
      };

      serverRemoteDownloadLimit = lib.mkOption {
        type = lib.types.int;
        default = 3;
        description = "Max concurrent remote downloads per server.";
      };

      remoteDownloadBlockedCidrs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "127.0.0.0/8"
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "169.254.0.0/16"
          "::1/128"
          "fe80::/64"
          "fc00::/7"
        ];
        description = "CIDR ranges blocked for remote downloads.";
      };

      disableDirectorySize = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Skip directory size calculations.";
      };

      directoryEntryLimit = lib.mkOption {
        type = lib.types.int;
        default = 10000;
        description = "Max entries returned per directory listing.";
      };

      sendOfflineServerLogs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Upload logs for stopped servers.";
      };

      fileSearchThreads = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Threads for file search operations.";
      };

      fileCopyThreads = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Threads for file copy operations.";
      };

      fileDecompressionThreads = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Threads for file decompression.";
      };

      fileCompressionThreads = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Threads for file compression.";
      };

      uploadLimit = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Max upload file size in MiB.";
      };

      maxJwtUses = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Max uses per JWT token.";
      };

      trustedProxies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Trusted proxy CIDRs for IP forwarding.";
      };
    };

    # ---- system section ----

    system = {
      rootDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pterodactyl";
        description = "Root data directory.";
      };

      logDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/pterodactyl";
        description = "Log file directory.";
      };

      vmountDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pterodactyl/vmounts";
        description = "Temporary mount points directory.";
      };

      data = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pterodactyl/volumes";
        description = "Server volume storage directory.";
      };

      archiveDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pterodactyl/archives";
        description = "Archive storage directory.";
      };

      backupDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/pterodactyl/backups";
        description = "Local backup storage directory.";
      };

      tmpDirectory = lib.mkOption {
        type = lib.types.path;
        default = "/tmp/pterodactyl";
        description = "Temporary file storage directory.";
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "pterodactyl";
        description = "System user for container processes.";
      };

      timezone = lib.mkOption {
        type = lib.types.str;
        default = "UTC";
        description = "Server timezone. Auto-detected if Wings runs on a non-NixOS host.";
      };

      user = {
        rootless = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Run containers in rootless mode.";
          };

          containerUid = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Container UID in rootless mode.";
          };

          containerGid = lib.mkOption {
            type = lib.types.int;
            default = 0;
            description = "Container GID in rootless mode.";
          };
        };

        uid = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Wings daemon process UID (auto-detected by Wings).";
        };

        gid = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Wings daemon process GID (auto-detected by Wings).";
        };
      };

      passwd = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Generate passwd/group files for containers (Linux only).";
        };

        directory = lib.mkOption {
          type = lib.types.path;
          default = "/run/wings/etc";
          description = "Passwd file directory.";
        };
      };

      machineId = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Expose machine ID to containers (Linux only).";
        };
      };

      diskCheckConcurrency = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Max concurrent disk checks.";
      };

      diskCheckInterval = lib.mkOption {
        type = lib.types.int;
        default = 150;
        description = "Seconds between disk checks.";
      };

      fullDiskCheckEvery = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Run full disk check every N intervals.";
      };

      diskCheckUseInotify = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use inotify for disk change detection.";
      };

      diskLimiterMode = lib.mkOption {
        type = lib.types.enum ["none" "btrfs_subvolume" "zfs_dataset" "xfs_quota" "fuse_quota"];
        default = "none";
        description = "Disk limiter mode.";
      };

      activitySendInterval = lib.mkOption {
        type = lib.types.int;
        default = 60;
        description = "Seconds between activity batch sends to panel.";
      };

      activitySendCount = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Max activity entries per batch.";
      };

      checkPermissionsOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Fix file permissions on startup.";
      };

      checkPermissionsOnBootThreads = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Threads for boot-time permission checks.";
      };

      websocketLogCount = lib.mkOption {
        type = lib.types.int;
        default = 150;
        description = "Max log lines kept in websocket buffer.";
      };

      # -- system sftp --

      sftp = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable the SFTP server.";
        };

        bindAddress = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "SFTP bind address.";
        };

        bindPort = lib.mkOption {
          type = lib.types.port;
          default = 2022;
          description = "SFTP listen port.";
        };

        readOnly = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Read-only SFTP access.";
        };

        keyAlgorithm = lib.mkOption {
          type = lib.types.str;
          default = "ssh-ed25519";
          description = "SFTP host key algorithm.";
        };

        disablePasswordAuth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Disable password authentication for SFTP.";
        };

        directoryEntryLimit = lib.mkOption {
          type = lib.types.int;
          default = 20000;
          description = "Max directory entries for SFTP listing.";
        };

        directoryEntrySendAmount = lib.mkOption {
          type = lib.types.int;
          default = 500;
          description = "Entries per SFTP response.";
        };

        limits = {
          authenticationPasswordAttempts = lib.mkOption {
            type = lib.types.int;
            default = 3;
            description = "Max password authentication attempts.";
          };

          authenticationPubkeyAttempts = lib.mkOption {
            type = lib.types.int;
            default = 20;
            description = "Max public key authentication attempts.";
          };

          authenticationCooldown = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Cooldown seconds after failed authentication.";
          };
        };

        shell = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the SFTP shell.";
          };

          cli = {
            name = lib.mkOption {
              type = lib.types.str;
              default = ".wings";
              description = "Shell CLI binary name.";
            };
          };
        };

        activity = {
          logLogins = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Log SFTP login events.";
          };

          logFileReads = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Log SFTP file read events.";
          };
        };
      };

      # -- system crash detection --

      crashDetection = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable crash detection.";
        };

        detectCleanExitAsCrash = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Treat clean exits as crashes.";
        };

        timeout = lib.mkOption {
          type = lib.types.int;
          default = 60;
          description = "Seconds before considering a server process as crashed.";
        };
      };

      # -- system file history --

      fileHistory = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable file version history.";
        };

        zstdLevel = lib.mkOption {
          type = lib.types.int;
          default = 19;
          description = "ZSTD compression level for history files.";
        };

        anchorInterval = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Anchor every N versions.";
        };

        keepChains = lib.mkOption {
          type = lib.types.int;
          default = 2;
          description = "Number of chains to retain.";
        };

        fileSizeCap = lib.mkOption {
          type = lib.types.int;
          default = 1048576;
          description = "Max file size to track in history, in bytes.";
        };

        perFileSizeCap = lib.mkOption {
          type = lib.types.int;
          default = 16777216;
          description = "Max per-file history storage, in bytes.";
        };

        perFileDiskBudget = lib.mkOption {
          type = lib.types.int;
          default = 5242880;
          description = "Per-file disk budget, in bytes.";
        };

        perServerDiskBudget = lib.mkOption {
          type = lib.types.int;
          default = 209715200;
          description = "Per-server disk budget, in bytes.";
        };

        maintenanceInterval = lib.mkOption {
          type = lib.types.int;
          default = 3600;
          description = "Maintenance interval in seconds.";
        };
      };

      # -- system backups --

      backups = {
        writeLimit = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Backup write rate limit in MiB (0 = unlimited).";
        };

        readLimit = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Backup read rate limit in MiB (0 = unlimited).";
        };

        compressionLevel = lib.mkOption {
          type = lib.types.enum ["best_speed" "good_speed" "good_compression" "best_compression"];
          default = "best_speed";
          description = "Backup compression level.";
        };

        mounting = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable backup mounting.";
          };

          path = lib.mkOption {
            type = lib.types.str;
            default = ".backups";
            description = "Mount path for backups.";
          };
        };

        wings = {
          createThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for local backup creation.";
          };

          restoreThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for local backup restoration.";
          };

          archiveFormat = lib.mkOption {
            type = lib.types.enum [
              "tar"
              "tar_gz"
              "tar_xz"
              "tar_lzip"
              "tar_bz2"
              "tar_lz4"
              "tar_zstd"
              "zip"
              "seven_zip"
            ];
            default = "tar_gz";
            description = "Archive format for local backups.";
          };
        };

        s3 = {
          createThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for S3 backup creation.";
          };

          partUploadTimeout = lib.mkOption {
            type = lib.types.int;
            default = 7200;
            description = "S3 part upload timeout in seconds.";
          };

          retryLimit = lib.mkOption {
            type = lib.types.int;
            default = 10;
            description = "S3 upload retry limit.";
          };
        };

        ddupBak = {
          createThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for ddup backup creation.";
          };

          compressionFormat = lib.mkOption {
            type = lib.types.enum ["none" "deflate" "gzip" "brotli"];
            default = "deflate";
            description = "Compression format for ddup backups.";
          };
        };

        restic = {
          repository = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/pterodactyl/backups/restic";
            description = "Restic repository path.";
          };

          passwordFile = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/pterodactyl/backups/restic_password";
            description = "Restic password file path.";
          };

          retryLockSeconds = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Restic lock retry interval in seconds.";
          };

          environment = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = {};
            description = "Restic environment variables.";
          };
        };

        btrfs = {
          restoreThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for Btrfs backup restore.";
          };

          createReadOnly = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Create Btrfs snapshots as read-only.";
          };
        };

        zfs = {
          restoreThreads = lib.mkOption {
            type = lib.types.int;
            default = 4;
            description = "Threads for ZFS backup restore.";
          };
        };
      };

      # -- system transfers --

      transfers = {
        downloadLimit = lib.mkOption {
          type = lib.types.int;
          default = 0;
          description = "Server transfer download rate limit in MiB (0 = unlimited).";
        };
      };
    };

    # ---- docker section ----

    docker = {
      socket = lib.mkOption {
        type = lib.types.str;
        default = "/var/run/docker.sock";
        description = "Docker daemon socket path or URL.";
      };

      serverNameInContainerName = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include server name in Docker container names.";
      };

      deleteContainerOnStop = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Remove containers when servers stop.";
      };

      network = {
        interface = lib.mkOption {
          type = lib.types.str;
          default = "172.18.0.1";
          description = "Docker bridge interface IP.";
        };

        disableInterfaceBinding = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Skip interface binding for Docker network.";
        };

        dns = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["1.1.1.1" "1.0.0.1"];
          description = "DNS servers for containers.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "pterodactyl_nw";
          description = "Docker network name.";
        };

        ispn = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use Internal Swarm Private Network.";
        };

        driver = lib.mkOption {
          type = lib.types.str;
          default = "bridge";
          description = "Docker network driver.";
        };

        mode = lib.mkOption {
          type = lib.types.str;
          default = "pterodactyl_nw";
          description = "Network mode for containers.";
        };

        isInternal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Internal network (no external access).";
        };

        enableIcc = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable inter-container communication.";
        };

        networkMtu = lib.mkOption {
          type = lib.types.int;
          default = 1500;
          description = "Network MTU.";
        };

        interfaces = {
          v4 = {
            subnet = lib.mkOption {
              type = lib.types.str;
              default = "172.18.0.0/16";
              description = "IPv4 subnet for the Docker network.";
            };

            gateway = lib.mkOption {
              type = lib.types.str;
              default = "172.18.0.1";
              description = "IPv4 gateway for the Docker network.";
            };
          };

          v6 = {
            subnet = lib.mkOption {
              type = lib.types.str;
              default = "fdba:17c8:6c94::/64";
              description = "IPv6 subnet for the Docker network.";
            };

            gateway = lib.mkOption {
              type = lib.types.str;
              default = "fdba:17c8:6c94::1011";
              description = "IPv6 gateway for the Docker network.";
            };
          };
        };
      };

      domainname = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Domain name for containers.";
      };

      registries = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
        description = "Private Docker registry credentials (attrs of {username, password}).";
      };

      tmpfsSize = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "tmpfs size in MiB.";
      };

      containerPidLimit = lib.mkOption {
        type = lib.types.int;
        default = 5120;
        description = "Max PIDs per container.";
      };

      installerLimits = {
        timeout = lib.mkOption {
          type = lib.types.int;
          default = 1800;
          description = "Server installer timeout in seconds.";
        };

        memory = lib.mkOption {
          type = lib.types.int;
          default = 1024;
          description = "Installer memory limit in MiB.";
        };

        cpu = lib.mkOption {
          type = lib.types.int;
          default = 100;
          description = "Installer CPU limit (100 = 1 core).";
        };
      };

      overhead = {
        override = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Override default overhead multipliers.";
        };

        defaultMultiplier = lib.mkOption {
          type = lib.types.float;
          default = 1.05;
          description = "Default memory overhead multiplier.";
        };

        multipliers = lib.mkOption {
          type = lib.types.attrsOf lib.types.float;
          default = {};
          description = "Memory → overhead multiplier map.";
        };
      };

      usernsMode = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "User namespace remapping mode.";
      };

      logConfig = {
        type = lib.mkOption {
          type = lib.types.str;
          default = "local";
          description = "Docker log driver type.";
        };

        config = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {
            max-size = "5m";
            max-file = "1";
            compress = "false";
            mode = "non-blocking";
          };
          description = "Docker log driver options.";
        };
      };
    };

    # ---- throttles section ----

    throttles = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable console output throttling.";
      };

      lines = lib.mkOption {
        type = lib.types.int;
        default = 2000;
        description = "Lines before throttling kicks in.";
      };

      lineResetInterval = lib.mkOption {
        type = lib.types.int;
        default = 100;
        description = "Milliseconds per line in throttle mode.";
      };
    };

    # ---- remote_query section ----

    remoteQuery = {
      timeout = lib.mkOption {
        type = lib.types.int;
        default = 30;
        description = "Panel API query timeout in seconds.";
      };

      bootServersPerPage = lib.mkOption {
        type = lib.types.int;
        default = 50;
        description = "Servers fetched per page on boot.";
      };

      retryLimit = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Max API retry attempts.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.virtualisation.docker.enable;
        message = "services.calagopus-wings requires virtualisation.docker.enable = true";
      }
    ];

    systemd.services.calagopus-wings = {
      description = "Calagopus Wings Daemon";
      wantedBy = ["multi-user.target"];
      after = ["docker.service" "network-online.target"];
      requires = ["docker.service"];
      wants = ["network-online.target"];

      preStart = ''
        mkdir -p /etc/pterodactyl
        mkdir -p /var/lib/pterodactyl/{volumes,vmounts,archives,backups}
        mkdir -p /var/log/pterodactyl
        mkdir -p /tmp/pterodactyl
        ${pkgs.gettext}/bin/envsubst < ${configYaml} > /etc/pterodactyl/config.yml
        chmod 600 /etc/pterodactyl/config.yml
      '';

      serviceConfig = {
        Type = "simple";
        User = "root";
        KillMode = "process";
        ExecStart = "${cfg.package}/bin/wings-rs --config /etc/pterodactyl/config.yml";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = "5s";
        StartLimitIntervalSec = 180;
        StartLimitBurst = 30;
        LimitNOFILE = 4096;
        WorkingDirectory = "/etc/pterodactyl";
        EnvironmentFile = cfg.environmentFile;

        # Security & hardening (matching panel.nix style)
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        UMask = "0077";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
        SystemCallErrorNumber = "EPERM";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RemoveIPC = true;
        PrivateUsers = true;
      };
    };

    # Create data directories via tmpfiles
    systemd.tmpfiles.rules = [
      "d /etc/pterodactyl 0750 root root -"
      "d /var/lib/pterodactyl 0750 root root -"
      "d /var/lib/pterodactyl/volumes 0750 root root -"
      "d /var/lib/pterodactyl/vmounts 0750 root root -"
      "d /var/lib/pterodactyl/archives 0750 root root -"
      "d /var/lib/pterodactyl/backups 0750 root root -"
      "d /var/log/pterodactyl 0750 root root -"
      "d /tmp/pterodactyl 1777 root root -"
    ];

    # Open firewall ports
    networking.firewall.allowedTCPPorts = [8080 2022];

    # Ensure Docker is enabled
    virtualisation.docker.enable = lib.mkDefault true;

    # Create the pterodactyl user for container processes
    users.users.pterodactyl = {
      isSystemUser = true;
      group = "pterodactyl";
      description = "Calagopus container process user";
    };
    users.groups.pterodactyl = {};
  };
}
