{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userEmail = "51096624+ferrumboll@users.noreply.github.com";
    userName = "ferrumboll";
    extraConfig = {
      pull.rebase = true;
      push.autoSetupRemote = true;
      credential."https://codeberg.org" = {
        username = "ferrumboll";
        helper = "libsecret";
      };
      http.postBuffer = 524288000;
    };
  };
}
