{ config, pkgs, theme, ... }:
{
    programs.librewolf = {
        enable = true;
        # package = pkgs.librewolf;
        # package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        #     extraPolicies = {
        #         CaptivePortal = false;
        #         DisableFirefoxStudies = true;
        #         DisablePocket = true;
        #         DisableTelemetry = true;
        #         DisableFirefoxAccounts = false;
        #         NoDefaultBookmarks = true;
        #         OfferToSaveLogins = false;
        #         OfferToSaveLoginsDefault = false;
        #         PasswordManagerEnabled = false;
        #         FirefoxHome = {
        #             Search = true;
        #             Pocket = false;
        #             Snippets = false;
        #             TopSites = false;
        #             Highlights = false;
        #         };
        #         UserMessaging = {
        #             ExtensionRecommendations = false;
        #             SkipOnboarding = true;
        #         };
        #     };
        # };
        profiles = {
            fer = {
                id = 0;
                name = "fer";
                search = {
                    force = true;
                    default = "Startpage";
                    engines = {
                        "Startpage" = {
                            urls = [{
                                template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto";
                            }];
                            icon = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
                            updateInterval = 24 * 60 * 60 * 1000; # every day
                            definedAliases = [ "@s" ];
                        };
                        "Nix Packages" = {
                            urls = [{
                                template = "https://search.nixos.org/packages";
                                params = [
                                    { name = "type"; value = "packages"; }
                                    { name = "query"; value = "{searchTerms}"; }
                                ];
                            }];
                            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                            definedAliases = [ "@np" ];
                        };
                        "NixOS Wiki" = {
                            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                            icon = "https://nixos.wiki/favicon.png";
                            updateInterval = 24 * 60 * 60 * 1000;
                            definedAliases = [ "@nw" ];
                        };
                        "Searx" = {
                            urls = [{ template = "http://searx.lan/search?q={searchTerms}&language=auto&safesearch=0"; }];
                            icon = "https://docs.searxng.org/_static/searxng-wordmark.svg";
                            definedAliases = [ "@searxng" "@searx" "@sx" ];
                            metaData.hidden = false;
                        };
                        "google".metaData.hidden = true;
                    };
                };
                extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
                    ublock-origin
                    bitwarden
                    clearurls
                    decentraleyes
                    consent-o-matic
                    stylus
                    sponsorblock
                    sourcegraph
                    octotree
                    simplelogin
                    purpleadblock
                    tree-style-tab
                    re-enable-right-click
                    # chameleon
                    # HistoryBlock
                    # TwitchNoSub
                    privacy-redirect
                    mullvad
                ];
                settings = {
                    "general.smoothScroll" = true;
                    "sidebar.revamp" = true;
                    "sidebar.verticalTabs" = true;
                    "identity.fxaccounts.enabled" = true; # sync with firefox account for mobile and other devices
                };
                # extraConfig = ''
                #     user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
                #     user_pref("layout.css.has-selector.enabled", true);
                #     user_pref("full-screen-api.ignore-widgets", true);
                #     user_pref("media.ffmpeg.vaapi.enabled", true);
                #     user_pref("media.rdd-vpx.enabled", true);
                # '';
                # userChrome = ''
                #  # a css 
                #  html#main-window body:has(#sidebar-box[sidebarcommand=treestyletab_piro_sakura_ne_jp-sidebar-action][checked=true]:not([hidden=true])) #TabsToolbar {
                #    visibility: collapse !important;
                #  }
                #
                #  @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
                # 
                # /* to hide the native tabs */
                # #TabsToolbar {
                #     visibility: collapse;
                # }
                # 
                # /* to hide the sidebar header */
                # #sidebar-header {
                #     visibility: collapse;
                # }
                # '';
                # userContent = ''
                #  # Here too
                # '';
            };
        };
    };
}
