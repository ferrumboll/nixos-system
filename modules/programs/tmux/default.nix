{ ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    catppuccin = {
      enable = true;
      extraConfig = ''
        # Configure the catppuccin plugin
        set -g @catppuccin_flavor "mocha"
        set -g @catppuccin_window_status_style "rounded"

        # Make the status line pretty and add some modules
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
        set -agF status-right "#{E:@catppuccin_status_cpu}"
        set -ag status-right "#{E:@catppuccin_status_session}"
        set -ag status-right "#{E:@catppuccin_status_uptime}"
        set -agF status-right "#{E:@catppuccin_status_battery}"
      '';
    };

    # plugins = with pkgs.tmuxPlugins; [
    #   {
    #     plugin = resurrect;
    #     extraConfig = ''
    #     set -g @resurrect-strategy-nvim 'session'
    #     '';
    #   }
    #
    #   {
    #     plugin = continuum;
    #     extraConfig = ''
    #     set -g @continuum-restore 'on'
    #     '';
    #   }
    # ];

    extraConfig = ''
    # configure default shell
    set -g default-command /etc/profiles/per-user/fer/bin/fish
    set -g default-shell /etc/profiles/per-user/fer/bin/fish

    set -g terminal-features sixel

    set-option -sg escape-time 10
    
    unbind C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix

    # split panes using | and -
    bind \\ split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

    # reload config file
    bind r source-file ~/.config/tmux/tmux.conf

    # switch panes using Alt-arrow without prefix
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D
    '';
    terminal = "xterm-256color";
  };
}
