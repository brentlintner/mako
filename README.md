# Mako

ATTENTION: I started using [Colloid](https://github.com/vinceliuice/Colloid-gtk-theme) instead of this, check it out!

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

The main [background.jpg](https://github.com/brentlintner/mako/raw/master/images/background.jpg) image is a grayscale version of the [Jet in Carina Nebula](https://www.google.com/search?q=jet+in+carina+background&sxsrf=ALeKk03Tg4XrWp1oA-694kWLB6qHl370Vg:1597436889880&tbm=isch&source=iu&ictx=1&fir=OAiw1rhvym_73M%252CcK6QtbgGz1CWTM%252C_&vet=1&usg=AI4_-kTApNpSM3-eLx9KZXTYPRRJq6KFGQ&sa=X&ved=2ahUKEwiB__ySxJvrAhUKhXIEHc6xB74Q9QEwBHoECAcQIA&biw=1920&bih=980#imgrc=OAiw1rhvym_73M) background.

#### Fonts

* Term font: [Inconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* Desktop font: [DejaVu Sans](https://dejavu-fonts.github.io)

#### Grub Theme

Based on Manjaro's [grub-theme](https://github.com/manjaro/grub-theme/tree/master/manjaro-live) but modded to have
a simple grayscale style with a different background image.

#### Gnome Shell Extensions

Some extensions I use to get Gnome even more customized.

* [user-themes](https://extensions.gnome.org/extension/1031/topicons/) (installed by `install.sh`)
* [vitals](https://github.com/corecoding/Vitals)
* [activities-configurator](https://extensions.gnome.org/extension/358/activities-configurator/) (start icons can be found in `/usr/share/icons/mako/places/symbolic/start-here-*.png`)
* [always-indicator](https://github.com/mzur/gnome-shell-always-indicator)
* [kstatus-notifier-item/appindicator-support](https://extensions.gnome.org/extension/615/appindicator-support/)
* [alternate-tab](https://extensions.gnome.org/extension/15/alternatetab/)
* [dash-to-dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
* [caffeine-ng](https://github.com/caffeine-ng/caffeine-ng) or [gnome-shell-extension-caffeine](https://github.com/eonpatapon/gnome-shell-extension-caffeine)
* [remove-dropdown-arrows](https://github.com/mpdeimos/gnome-shell-remove-dropdown-arrows)
* [remove-alt-tab-delay](https://github.com/BjoernDaase/remove-alt-tab-delay)
* [no-annoyance](https://github.com/BjoernDaase/noannoyance)
* [disable-workspace-switcher-popup](https://github.com/windsorschmidt/disable-workspace-switcher-popup)
* [applications-menu](https://gitlab.gnome.org/GNOME/gnome-shell-extensions)
* [sound-and-input-device-chooser](https://github.com/kgshank/gse-sound-output-device-chooser)
* [big-avatar](https://extensions.gnome.org/extension/2494/bigavatar/)

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
