# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
# let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; }; in
{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    nix.package = pkgs.nixFlakes;
    nix.extraOptions = "experimental-features = nix-command flakes";

    # use grub bootloader
    boot.loader = {
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
        grub = {
            enable = true;
            version = 2;
            efiSupport = true;
            device = "nodev";
            useOSProber = true;
        };
    };
    boot.supportedFilesystems = [ "ntfs" ];

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Berlin";
    time.hardwareClockInLocalTime = true;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";

        displayManager = {
            startx.enable = true;
            # gdm = {
            #   enable = true;
            #   wayland = true;
            #   nvidiaWayland = true;
            # };

            gdm.enable = true;
        };

        desktopManager.gnome.enable = true;

        videoDrivers = [ "nvidia" ];
    };

    # nvidia drivers
    hardware.opengl = {
        enable = true;
        # driSupport = true;
        # driSupport32Bit = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    services.avahi = {
        nssmdns = true;
        enable = true;
        publish = {
            enable = true;
            userServices = true;
            domain = true;
        };
    };

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    # hardware.pulseaudio.systemWide = true;

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        # jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.david = {
        isNormalUser = true;
        description = "david";
        extraGroups = [ "networkmanager" "wheel" ];

        packages = with pkgs; [
            firefox
            kate
            thunderbird
        ];
    };
    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh bash ];

    programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
    };

    programs.starship = {
        enable = true;

        settings = {

        };
    };

    # docker osx: https://nixos.wiki/wiki/OSX-KVM
    virtualisation.libvirtd.enable = true;
    users.extraUsers.david.extraGroups = [ "libvirtd" ];
    boot.extraModprobeConfig = ''
        options kvm_intel nested=1
        options kvm_intel emulate_invalid_guest_state=0
        options kvm ignore_msrs=1
    '';

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim
        wget
        htop
        neofetch
        pciutils
        uxplay
        thokr
        geogebra

        # dev tools
        alacritty
        neovim
        xclip # nvim clipboard support
        vimPlugins.packer-nvim
        lapce
        craftos-pc
        texlive.combined.scheme-full
        docker
        gnumake
        just

        git
        gh
        mold
        imhex
        ripgrep
        discord
        prismlauncher
    
        # libs
        pkg-config-unwrapped
        alsa-lib
        easyeffects
        rustdesk
        watchexec
        opendrop
        openssl
        owl

        # languages
        llvm
        llvmPackages.libcxxClang
        libgccjit

        rustup cargo-watch rust-analyzer
        go gopls
    
        nodejs
        deno
        nodePackages.svelte-language-server
        nodePackages.typescript-language-server
        nodePackages.vscode-html-languageserver-bin
        nodePackages.vscode-css-languageserver-bin

        # unstable
        # unstable.typst
        # unstable.typst-lsp
    ];

    fonts.fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    ];

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

    networking.firewall.allowedTCPPorts = [
        # minecraft
        25565

        # airplay
        # from https://taoa.io/posts/Setting-up-ipad-screen-mirroring-on-nixos
        7100
        7000
        7001
        5001

        # webdev
        9000
        3000
        3001
        3002
        3003
    ];
    networking.firewall.allowedUDPPorts = [
        # minecraft
        25565

        # airplay
        6000
        6001
        7011
    ];

    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
}

