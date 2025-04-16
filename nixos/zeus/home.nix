{
  pkgs,
  ...
}: {
  home = {
    sessionVariables = {
    };

    packages = with pkgs; [
      krita
    ];
  };
}
