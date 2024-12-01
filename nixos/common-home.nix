{
  pkgs,
  user,
  ...
}:
{
  imports = import ../modules;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };

    packages = with pkgs; [
    ];

    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
