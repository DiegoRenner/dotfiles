# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	services = {
		asusd = {
			enable = true;
			enableUserService = true;
		};
	};

	services.fwupd.enable = true;
	programs.fish.enable = true;
	programs.bash = {
		interactiveShellInit = ''
			if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
				then
					shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
					exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
					fi
					'';
	};

# Use latest kernel.
	boot.kernelPackages = pkgs.linuxPackages_zen;
#boot.kernelPackages = let
#  #nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.zstd ];
#	
#      linux_sgx_pkg = { fetchurl, buildLinux, ... } @ args:
#
#        buildLinux (args // rec {
#          version = "6.9";
#          modDirVersion = version;
#
#	src = /home/diego/Downloads/linux-g14-6.9.arch1-1.2-x86_64.pkg.tar.gz;
#          #src = fetchurl {
#          #  url = "https://arch.asus-linux.org/linux-g14-6.9.arch1-1.2-x86_64.pkg.tar.zst";
#          #  # After the first build attempt, look for "hash mismatch" and then 2 lines below at the "got:" line.
#          #  # Use "sha256-....." value here.
#          #  hash = "sha256-idwZAbEcJSbeNNx1r7HPE+OoORANcPwHg4/z1TgmA7E";
#          #};
#          kernelPatches = [];
#
#          #extraConfig = ''
#          #  INTEL_SGX y
#          #'';
#
#          extraMeta.branch = "6.9";
#        } // (args.argsOverride or {}));
#      linux_sgx = pkgs.callPackage linux_sgx_pkg{};
#    in 
#      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sgx);

	networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
		networking.networkmanager.enable = true;

# Set your time zone.

# Select internationalisation properties.
	i18n.defaultLocale = "en_GB.UTF-8";


	i18n.extraLocaleSettings = {
		LC_ADDRESS = "de_CH.UTF-8";
		LC_IDENTIFICATION = "de_CH.UTF-8";
		LC_MEASUREMENT = "de_CH.UTF-8";
		LC_MONETARY = "de_CH.UTF-8";
		LC_NAME = "de_CH.UTF-8";
		LC_NUMERIC = "de_CH.UTF-8";
		LC_PAPER = "de_CH.UTF-8";
		LC_TELEPHONE = "de_CH.UTF-8";
		LC_TIME = "de_CH.UTF-8";
	};

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "gb";
		variant = "";
	};


# Configure console keymap
	console.keyMap = "uk";
# services.libinput.touchpad.NaturalScrolling.enable = false;

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.diego = {
		isNormalUser = true;
		description = "Diego Renner";
		extraGroups = [ "networkmanager" "wheel" "gamemode" "docker"];
		packages = with pkgs; [
		];
	};

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
# For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
	environment.sessionVariables = rec {
		FILE = "thunar";
		EDITOR = "nvim";
	};

# programs.hyprland.enable = true;
	programs.hyprland = {
# Install the packages from nixpkgs
		enable = true;
# Whether to enable XWayland
		xwayland.enable = true;
	};
# services.displayManager.gdm.enable = true;
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;

	programs.steam = {
		enable = true;
# Milan recommendation, not necessary after all
# extraCompatPackages = with pkgs; [
#   proton-ge-bin
# ];
	};

# not necessary since installing steam via enable
# hardware.graphics.extraPackages = with pkgs; [
#   vulkan-loader
#   vulkan-validation-layers
#   vulkan-extension-layer
# ];

# tried for steam scaling but both didn't do anything
# environment.sessionVariables.QT_QPA_PLATFORM = "wayland";
# programs.steam.gamescopeSession.enable = true;

# optimisations for running games
	programs.gamemode.enable = true;



# Enable OpenGL
	hardware.graphics = {
		enable = true;
	};
# For offloading, `modesetting` is needed additionally,
# otherwise the X-server will be running permanently on nvidia,
# thus keeping the GPU always on (see `nvidia-smi`).
	services.xserver.videoDrivers = [
		"amdgpu"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
			"nvidia"
	];
# Load nvidia driver for Xorg and Wayland
	hardware.nvidia.prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
#sync.enable = true;
# Make sure to use the correct Bus ID values for your system!
		nvidiaBusId = "PCI:100:0:0";
# intelBusId = "PCI:0:2:0";
		amdgpuBusId = "PCI:101:0:0";
	};
	programs.waybar.enable = true;
	hardware.bluetooth.enable = true; # enables support for Bluetooth
		hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
		hardware.nvidia = {

# Modesetting is required.
			modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
			powerManagement.enable = true;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
			powerManagement.finegrained = true;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
			open = true;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
			nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
			package = config.boot.kernelPackages.nvidiaPackages.latest;
		};

# for correct brave scaling
	environment.sessionVariables.NIXOS_OZONE_WL = "1";

# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
		devpod
		granted
		signal-desktop-bin
		libredirect
		nix-index
		proxychains
		wdisplays
		grim
		feh
		awscli2
			distant
			flex
			blas
			lapack
			xfce.thunar
			kitty
			(brave.override { commandLineArgs = [ "--ozone-platform-hint=auto" ]; })
			neovim
			lshw
			copyq
			mesa-demos
# not necessary since installing steam via enable
# vulkan-tools
			wofi
			networkmanagerapplet
			git
			mlocate
			pass
			gnupg
			wl-clipboard
			chezmoi
			cocogitto
			brightnessctl
			acpilight
			unzip
			vesktop
			pinentry
			zoxide
# lazyvim dependencies
			lazygit
			gcc
			curl
			fzf
			ripgrep
			fd
			nodejs
			gnumake
			cmake
			zstd
			nvtopPackages.nvidia
#(pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion ["github-copilot"])
			(pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion ["ideavim"])
#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#  wget
			];

# Optional, but this is needed for `nix-alien-ld` command
	programs.nix-ld.enable = true;
	programs.gnupg.agent.enable = true;

# install all nerdfonts
	fonts.packages = builtins.filter lib.attrsets.isDerivation
		(builtins.attrValues pkgs.nerd-fonts);
	services.automatic-timezoned.enable = true;
	virtualisation.docker.enable = true;





# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };


# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
