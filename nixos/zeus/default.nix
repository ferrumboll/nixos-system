{ user, ... }: {
  imports = [(import ./hardware-configuration.nix) (import ../../modules/services/syncthing)];

  networking = {
    hostName = "zeus";
    networkmanager.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
    };
  };

  #programs.sleepy-launcher.enable = true;
  #programs.honkers-railway-launcher.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "/home/${user}/.steam/root/compatibilitytools.d";
  };
}
