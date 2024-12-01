# References:
# https://github.com/azuwis/nix-config/blob/885e77f74bd730f37d715c6a7ed1a9269a619f7d/common/neovim/nvchad.nix
{pkgs, config, ...}: {

  home.packages = with pkgs; [
    ripgrep

    # lsp
    # rnix-lsp
    nodejs
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    catppuccin.enable = false;
  };
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/programs/neovim/dotfiles";
}
