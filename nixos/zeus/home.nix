{
  pkgs,
  ...
}: {
  home = {
    sessionVariables = {
    };

    packages = with pkgs; [
      obsidian
      krita
      freetube
      opencommit
    ];
  };
}
