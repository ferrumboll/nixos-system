{ ... }: {
  programs.starship = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        character = {
          success_symbol = "[[♥](green) ❯](maroon)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };
        # directory = {
        #     truncation_length = 4;
        #     truncation_symbol = "…";
        #     style = "bold lavender";
        # };
      };
    };
}
