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
      sops
      gopass

      bitwarden-cli

      birdtray

      stremio

      cachix
      obsidian
      libreoffice

      git
      git-credential-manager
      vim
      unzip
      lutris

      tlrc

      termusic
      yt-dlp
      ffmpeg

      youtube-tui
      twitch-tui

      fishPlugins.fzf-fish
      fishPlugins.forgit

      exercism
      streamlink

      marksman
      tree-sitter
      nil

      beeper

      freetube
      xclip

      opencommit
    ];

    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;
  };
}
