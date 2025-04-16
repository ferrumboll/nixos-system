{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      "gc" = "git commit";
      "gs" = "git status";
      "ga" = "git add -A";
      "gp" = "git pull";
      "gps" = "git push";
      "gdn" = "git diff --name-only";
      "lg" = "lazygit";
      "ld" = "lazydocker";
      "n." = "nvim .";
      "e." = "nautilus .";
      "oo" = "cd $HOME/Documents/BIG && nvim .";
      "nd." = "develop -c \"nvim .\"";
      "sql" = "nix-shell -p sqlfluff --run \"nvim '+SQLua'\"";
      "cf" = "xclip -sel clip ";
    };
    shellAliases = {
      "vim" = "nvim";
      "n" = "nvim";
      "stl" = "streamlink";
    };
    shellInit = ''
      zoxide init fish | source
      atuin gen-completions --shell fish | source
      atuin init fish --disable-up-arrow | source
      any-nix-shell fish --info-right | source
      starship init fish | source
      direnv hook fish | source
    '';

    plugins = [
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "fzf.fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];

    functions = {
      develop = {
        description = "";
        wraps = "nix develop";
        body = ''
          set command ""
      
          # Parse arguments
          for arg in $argv
              if [ $arg = "-c" ]
                  set command "-c"
              else if [ $command = "-c" ]
                  set command "-c $arg"
              end
          end

          if [ "$argv" = -i ]
              env ANY_NIX_SHELL_PKGS=(basename (pwd))"#"(git describe --tags --dirty) (type -P nix) develop --command fish
          end

          switch $IN_NIX_SHELL
              case ""
                  if [ "$command" = "" ]
                      env ANY_NIX_SHELL_PKGS=(basename (pwd))"#"(git describe --tags --dirty) (type -P nix) develop --command fish
                  else
                      env ANY_NIX_SHELL_PKGS=(basename (pwd))"#"(git describe --tags --dirty) (type -P nix) develop --command fish $command
                  end
              case "*"
                  echo "Already in a nix shell"
          end
        '';
      };
      envsource = {
        description = "";
        body = ''
          set -f envfile "$argv"
          if not test -f $envfile
              echo "File not found: $envfile"
              return 1
          end

          while read line
              if not string match -qr '^#|^$' line
                  set item (string split -m1 '=' $line)
                  set -gx $item[1] $item[2]
                  echo "Exported $item[1]"
              end
          end <"$envfile"
        '';
      };
      tree = {
        description = "";
        body = ''
          set -l args $argv

          # Check if --level flag is present in the arguments
          if not contains -- '--level' $args
              set args --level 1 $args
          end

          eza --long --tree --no-user -h --no-permissions --no-time -s size --total-size $args
        '';
      };
      bsevpn = {
        description = "Get creds and connect to work vpn";
        body = ''
          bw login --apikey
          set BW_SESSION $(bw unlock --passwordenv BW_PASSWORD | string match -r ''\'\"(.*)\"''\' | head -n 1 | string replace ''\'"''\' ''\'''\')
          echo "fernando.llanos@bestseller.com" > /tmp/file.txt
          echo $(bw get password "[BSE] BESTSELLER Okta" --session $BW_SESSION),$(bw get totp "[BSE] BESTSELLER Okta" --session $BW_SESSION) >> /tmp/file.txt
          sudo openvpn --config /home/fer/Documents/BSE/client.ovpn --auth-user-pass /tmp/file.txt
        '';
      };
    };
  };

  # files in ./conf.d/ will be copied to ~/.config/fish/conf.d/
  xdg.configFile."fish/conf.d/venv.fish".source = ./conf.d/venv.fish;
}
