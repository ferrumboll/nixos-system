{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "51096624+ferrumboll@users.noreply.github.com";
    userName = "ferrumboll";
    extraConfig = {
      # https://stackoverflow.com/questions/16906161/git-push-hangs-when-pushing-to-github
      http.postBuffer = 524288000;
    };
  };
}
