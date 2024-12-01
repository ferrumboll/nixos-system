{ pkgs, ... }:
{
    programs.firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
            extraPolicies = {
                CaptivePortal = false;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableTelemetry = true;
                DisableFirefoxAccounts = false;
                NoDefaultBookmarks = true;
                OfferToSaveLogins = false;
                OfferToSaveLoginsDefault = false;
                PasswordManagerEnabled = false;
                FirefoxHome = {
                    Search = true;
                    Pocket = false;
                    Snippets = false;
                    TopSites = false;
                    Highlights = false;
                };
                UserMessaging = {
                    ExtensionRecommendations = false;
                    SkipOnboarding = true;
                };
            };
        };
        profiles = {
            fer = {
                id = 0;
                name = "fer";
                search = {
                    force = true;
                    default = "Searx";
                    engines = {
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
                            iconUpdateURL = "https://nixos.wiki/favicon.png";
                            updateInterval = 24 * 60 * 60 * 1000;
                            definedAliases = [ "@nw" ];
                        };
                        "Searx" = {
                            urls = [{ template = "http://searx.lan/search?q={searchTerms}&language=auto&safesearch=0"; }];
                            iconUpdateURL = "https://docs.searxng.org/_static/searxng-wordmark.svg";
                            definedAliases = [ "@searxng" "@searx" "@sx" ];
                            metaData.hidden = false;
                        };
                        "Wikipedia (en)".metaData.alias = "@wiki";
                        "Google".metaData.hidden = true;
                        "Amazon.com".metaData.hidden = true;
                        "Bing".metaData.hidden = true;
                    };
                };
                extensions = with pkgs.nur.repos.rycee.firefox-addons; [
                    keepassxc-browser
                    ublock-origin
                    bitwarden
                    clearurls
                    decentraleyes
                    kagi-search
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
                };
                extraConfig = ''
                    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
                    user_pref("layout.css.has-selector.enabled", true);
                    user_pref("full-screen-api.ignore-widgets", true);
                    user_pref("media.ffmpeg.vaapi.enabled", true);
                    user_pref("media.rdd-vpx.enabled", true);
                '';
                userChrome = ''
                 # a css 
                 html#main-window body:has(#sidebar-box[sidebarcommand=treestyletab_piro_sakura_ne_jp-sidebar-action][checked=true]:not([hidden=true])) #TabsToolbar {
                   visibility: collapse !important;
                 }

                 @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
                
                /* to hide the native tabs */
                #TabsToolbar {
                    visibility: collapse;
                }
                
                /* to hide the sidebar header */
                #sidebar-header {
                    visibility: collapse;
                }
                '';
                userContent = ''
                 # Here too
                '';
            };
        };
    };
}
