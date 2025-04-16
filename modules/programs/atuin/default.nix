{ ... }: {
  programs.atuin = {
    enable = true;
    settings = {
      sync_address = "http://atuin.lan";
    };
  };
}
