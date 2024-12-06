{ user, ... }:
{
  services = {
    syncthing = {
        enable = true;
        user = "${user}";
        dataDir = "/home/${user}/Documents";    # Default folder for new synced folders
        configDir = "/home/${user}/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };
}
