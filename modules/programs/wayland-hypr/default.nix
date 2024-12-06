{config, pkgs, ...}: {
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    extraConfig = builtins.readFile ../../../system/desktop/hyprland/home/conf/hyprland.conf;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  home.file."wallpaper.png".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/1210768.png";
  home.file.".config/hypr/env.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/env.conf";
  home.file.".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/hyprpaper.conf";
  home.file.".config/hypr/keybinds.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/keybinds.conf";
  home.file.".config/hypr/startup.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/startup.conf";
  home.file.".config/hypr/windowrule.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/windowrule.conf";
  home.file.".config/hypr/mocha.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/system/modules/system/desktop/hyprland/home/conf/mocha.conf";
}
