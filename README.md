# Mako

A simple, modern and elegant grayscale theme for GTK+ desktops.

![screenshot example](https://raw.githubusercontent.com/brentlintner/mako/master/screenshot.png)

## Notice

I currently use this as a personal install script to quickly setup a
consistent GNU/Linux look and feel alongside my [dot-files](https://github.com/brentlintner/dot-files) and [vim-settings](https://github.com/brentlintner/vim-settings), primarily using gnome-shell as the DE.

## Features

* A material design based grayscale interface, shell and gdm theme
* Simple, solid cursor default
* Rich, layered icon sets
* Beautiful background, grub theme, and lock screen
* Console and DE font configs
* Extra config files for Qt5 theme mapping, setting gdm cursor, etc

#### GTK+ Theme

The interface and gnome-shell theme uses [Materia](https://github.com/nana-4/materia-theme).

Colour palette was inspired by [Vimix](https://github.com/vinceliuice/vimix-gtk-themes).

#### Cursor Theme

Uses the [DMZ](https://www.gnome-look.org/p/999970) cursor.

#### Icon Theme

Primarily uses the [Vertex](https://github.com/horst3180/vertex-icons) icon set with fallback to the [Paper](https://github.com/snwh/paper-icon-theme) icon set.

#### Background

The main [background.png](https://github.com/brentlintner/mako/raw/master/images/background.png) image is originally from [InterfaceLift](https://interfacelift.com/wallpaper/details/4129/zuiderheide.html).

#### Fonts

* Term font: [Inconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* Desktop font: [DejaVu Sans](https://dejavu-fonts.github.io)

#### Grub Theme

Based on Manjaro's [grub-theme](https://github.com/manjaro/grub-theme/tree/master/manjaro-live) but modded to have
a simple grayscale style with a different background image.

#### Gnome Shell Extensions

To get the look shown in the screenshot you need to install other extensions manually.

* [user-themes](https://extensions.gnome.org/extension/1031/topicons/) (installed by `install.sh`)
* [activities-configurator](https://extensions.gnome.org/extension/358/activities-configurator/) (start icons can be found in `/usr/share/icons/mako/places/symbolic/start-here-*.png`)
* [alternate-tab](https://extensions.gnome.org/extension/15/alternatetab/)
* [dash-to-dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [hide-top-bar](https://extensions.gnome.org/extension/545/hide-top-bar/)
* [kstatus-notifier-item/appindicator support](https://extensions.gnome.org/extension/615/appindicator-support/)
* [{manjaro,arch}-linux-updates-indicator](https://extensions.gnome.org/extension/1010/archlinux-updates-indicator/) (in respective repos)
* [media-player-indicator](https://extensions.gnome.org/extension/55/media-player-indicator/)
* [openweather](https://extensions.gnome.org/extension/750/openweather/)
* [pomodoro](https://extensions.gnome.org/extension/53/pomodoro/)
* [removable-drive-menu](https://extensions.gnome.org/extension/7/removable-drive-menu/)
* [topicons-plus](https://extensions.gnome.org/extension/1031/topicons/)
* [status-area-horizontal-spacing](https://extensions.gnome.org/extension/355/status-area-horizontal-spacing/)

## Supported OSes

* Arch/Manjaro
* Fedora/CentOS
* Ubuntu/Debian
* openSUSE (need to install [gnome-extension-user-theme](https://extensions.gnome.org/extension/19/user-themes) manually)
* macOS (just the fonts)

## Requirements

* glib based DE such as gnome-shell or Unity (limited support on DEs like XFCE, etc)
* Xorg (gnome-shell extensions + Wayland not 100%)

## Install
```sh
$ git clone git@github.com:brentlintner/mako.git ~/.mako
$ cd ~/.mako
$ ./install.sh
$ sudo reboot
```
Note: On OSes without `sudo` it might be way less annoying to just run `install.sh` as root.

## Uninstall
```sh
$ cd ~/.mako
$ ./install.sh --revert
$ sudo reboot
```
Note: still leaves various system packages installed/set (ex: fonts).

## Workarounds

* Chromium tabs have dark text on a dark bg.

Set [chrome://flags/#top-chrome-md]() to Normal.
