{ ... }: {
  programs.feh = {
    enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/git" = "feh.desktop";
      "image/bmp" = "feh.desktop";
      "image/tiff" = "feh.desktop";
      "image/webp" = "feh.desktop";
    };
  };

  home.file.".local/share/applications/feh.desktop".text = ''
    [Desktop Entry]
    Name=Feh
    Exec=feh %U
    Icon=feh
    Type=Application
    Categories=Graphics;
    MimeType=image/png;image/jpeg;image/gif;image/bmp;image/tiff;image/webp;
    '';
}
