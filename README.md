# Mako

A beautiful grayscale meta theme installer for GTK+ based desktops.

![screenshot example](https://raw.githubusercontent.com/brentlintner/mako/master/screenshot.png)

## Notice

I currently use this as a personal install script to quickly setup a
consistent GNU/Linux look and feel alongside my [dot-files](https://github.com/brentlintner/dot-files) and [vim-settings](https://github.com/brentlintner/vim-settings), primarily using gnome-shell as the DE.

It's probably best to take this as a reference point and/or install each project in a less manual way (ex: via package manager).

## Supported OSes

* Ubuntu
* Debian
* Arch
* Fedora
* openSUSE (need to install [gnome-extension-user-theme](https://extensions.gnome.org/extension/19/user-themes) manually)
* CentOS
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

## Features

* A material design based grayscale interface, shell and gdm theme
* Simple cursor with transparency
* Rich, layered icon sets
* Beautiful background, grub theme, and lock screen
* Console and DE font configs
* Extra config files to make GDM honour custom cursors, etc

### GTK+ Theme

The interface and gnome-shell theme uses [Materia](https://github.com/nana-4/materia-theme).

### Cursor Theme

Uses the [Simple-and-Soft](https://www.gnome-look.org/p/999946/) cursor.

### Icon Theme

Primarily uses the [Vertex](https://github.com/horst3180/vertex-icons) icon set with fallback to the [Paper](https://github.com/snwh/paper-icon-theme) icon set.

### Background / Lock Screen

The [bg/bg.png](bg/bg.png) image (also used in the grub theme) is originally from [InterfaceLift](https://interfacelift.com/wallpaper/details/4129/zuiderheide.html).

### Fonts

* Term font: [Inconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
* Desktop font: [DejaVu Sans](https://dejavu-fonts.github.io)

### Grub Theme

Based on [Manjaro's](https://github.com/manjaro/grub-theme/tree/master/manjaro-live) but modded to have
a simple grayscale style with a different bg image.

## Uninstall
```sh
$ cd ~/.mako
$ ./install.sh --revert
$ sudo reboot
```
Note: still leaves various system packages installed/set (ex: fonts).
