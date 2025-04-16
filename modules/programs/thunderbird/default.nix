{ config, user, pkgs, ... }: {
  systemd.user.services.thunderbird-tray = {
     Unit = {
        Description = "Mozilla Thunderbird System Tray (birdtray) service";
        After = "waybar.service";
     };
     Service = {
        ExecStart = "${pkgs.birdtray}/bin/birdtray -l /home/${user}/.config/thunderbird/birdtray.log";
        Restart = "on-failure";
        RestartSec = 5;
     };
     Install.WantedBy = [ "default.target" ];
  };

  sops.secrets."mail_pass" = {
    sopsFile = ./secrets.yaml;
    path = "/home/${user}/.config/thunderbird/pass";
  };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };

  accounts.email.accounts = {
    fastmail = rec {
      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
      # {{{ Primary config
      address = "ferrumbo@pxlf.me";
      realName = "Fernando Rumbo";
      userName = address;
      aliases = ["fer@pxlf.me" "fernando@pxlf.me"];

      folders = {
        inbox = "Inbox";
        sent = "Sent";
        drafts = "Drafts";
        trash = "Trash";
      };

      passwordCommand = "cat ${config.sops.secrets.mail_pass.path}";
      primary = true;
      # }}}
      # {{{ Imap / smtp configuration
      imap = {
        host = "imap.fastmail.com";
        port = 993;
      };

      smtp = {
        host = "smtp.fastmail.com";
        port = 465;
      };

      msmtp = {
        enable = true;
      };

      mbsync = {
        enable = true;
        create = "both"; # sync folders both ways
        expunge = "maildir"; # Delete messages when the local dir says so
      };

      aerc = {
        enable = true;
      };

      notmuch = {
        enable = true;
        neomutt.enable = true;
      };

      neomutt = {
        enable = true;
        sendMailCommand = "msmtpq --read-envelope-from --read-recipients";
        extraMailboxes = [
          "Archive"
          "Drafts"
          "Sent"
          "Trash"
        ];
      };
    };
  };

  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };

  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };

  programs.neomutt = {
    # {{{ Primary config
    enable = true;
    vimKeys = true;
    checkStatsInterval = 60; # How often to check for new mail
    sidebar = {
      enable = true;
      width = 30;
    };

    extraConfig = ''
      # Starting point: https://seniormars.com/posts/neomutt/#introduction-and-why
      # {{{ Settings
      set pager_index_lines = 10
      set pager_context = 3                # show 3 lines of context
      set pager_stop                       # stop at end of message
      set menu_scroll                      # scroll menu
      set tilde                            # use ~ to pad mutt
      set move=no                          # don't move messages when marking as read
      set sleep_time = 0                   # don't sleep when idle
      set wait_key = no		     # mutt won't ask "press key to continue"
      set envelope_from                    # which from?
      # set edit_headers                     # show headers when composing
      set fast_reply                       # skip to compose when replying
      set askcc                            # ask for CC:
      set fcc_attach                       # save attachments with the body
      set forward_format = "Fwd: %s"       # format of subject when forwarding
      set forward_decode                   # decode when forwarding
      set forward_quote                    # include message in forwards
      set mime_forward                     # forward attachments as part of body
      set attribution = "On %d, %n wrote:" # format of quoting header
      set reply_to                         # reply to Reply to: field
      set reverse_name                     # reply as whomever it was to
      set include                          # include message in replies
      set text_flowed=yes                  # correct indentation for plain text
      unset sig_dashes                     # no dashes before sig
      unset markers
      # }}}
      # {{{ Sort by newest conversation first.
      set charset = "utf-8"
      set uncollapse_jump
      set sort_re
      set sort = reverse-threads
      set sort_aux = last-date-received
      # }}}
      # {{{ How we reply and quote emails.
      set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
      set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
      set send_charset = "utf-8:iso-8859-1:us-ascii" # send in utf-8
      # }}}
      # {{{ Sidebar
      set sidebar_visible # comment to disable sidebar by default
      set sidebar_short_path
      set sidebar_folder_indent
      set sidebar_format = "%B %* [%?N?%N / ?%S]"
      set mail_check_stats
      # }}}
      # {{{ Theme
      color normal		  default default         # Text is "Text"
      color index		    color2 default ~N       # New Messages are Green
      color index		    color1 default ~F       # Flagged messages are Red
      color index		    color13 default ~T      # Tagged Messages are Red
      color index		    color1 default ~D       # Messages to delete are Red
      color attachment	color5 default          # Attachments are Pink
      color signature	  color8 default          # Signatures are Surface 2
      color search		  color4 default          # Highlighted results are Blue
      
      color indicator		default color8          # currently highlighted message Surface 2=Background Text=Foreground
      color error		    color1 default          # error messages are Red
      color status		  color15 default         # status line "Subtext 0"
      color tree        color15 default         # thread tree arrows Subtext 0
      color tilde       color15 default         # blank line padding Subtext 0
      
      color hdrdefault  color13 default         # default headers Pink
      color header		  color13 default "^From:"
      color header	 	  color13 default "^Subject:"
      
      color quoted		  color15 default         # Subtext 0
      color quoted1		  color7 default          # Subtext 1
      color quoted2		  color8 default          # Surface 2
      color quoted3		  color0 default          # Surface 1
      color quoted4		  color0 default
      color quoted5		  color0 default
      
      color body		color2 default		[\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+               # email addresses Green
      color body	  color2 default		(https?|ftp)://[\-\.,/%~_:?&=\#a-zA-Z0-9]+        # URLs Green
      color body		color4 default		(^|[[:space:]])\\*[^[:space:]]+\\*([[:space:]]|$) # *bold* text Blue
      color body		color4 default		(^|[[:space:]])_[^[:space:]]+_([[:space:]]|$)     # _underlined_ text Blue
      color body		color4 default		(^|[[:space:]])/[^[:space:]]+/([[:space:]]|$)     # /italic/ text Blue
      
      color sidebar_flagged   color1 default    # Mailboxes with flagged mails are Red
      color sidebar_new       color10 default   # Mailboxes with new mail are Green
      '';
  };
}
