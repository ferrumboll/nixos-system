{ ... }: {
  programs.mpv = {
    enable = true;
  };

  xdg.configFile."mpv/mpv.conf".source = ./mpv.conf;
}
