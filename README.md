# Mako

A dark, pleasant and full featured GNU/Linux GTK+ meta theme.

![screenshot example](https://raw.githubusercontent.com/brentlintner/mako/master/screenshot.png)

## Notice

I currently use this as a convenience repo alongside my [dot-files](https://github.com/brentlintner/dot-files) and [vim-settings](https://github.com/brentlintner/vim-settings) to quickly setup a consistent GNU/Linux system.

For the most part this is just an install script and mirror files for projects that
can't be mapped as sub modules.

## Install
```sh
$ git clone git@github.com:brentlintner/mako.git ~/.mako
$ cd ~/.mako
$ ./install.sh --prefix /usr/share
```
## Features

* A slick grayscale interface and shell theme
* Simple cursor with transparency
* Layered icon sets
* Beautiful backgrounds
* Custom grub theme
* Console and DE font configs
* Other misc. Gnome configs

## GTK+ Theme

The interface and gnome-shell theme is [Vimix](https://github.com/vinceliuice/vimix-gtk-themes), a material design based GTK+/gnome-shell theme based on [Materia](https://github.com/nana-4/materia-theme).

## Cursor Theme

Uses the [simple-and-soft](https://www.gnome-look.org/p/999946/) cursor.

## Icon Theme

Primarily uses the [Vertex](https://github.com/horst3180/vertex-icons) icon set with fallback to the [Paper](https://github.com/snwh/paper-icon-theme) icon set.

## Background / Lock Screen

The `bg/bg.png` image (also used in grub theme) is originally from [InterfaceLift](https://interfacelift.com/wallpaper/details/4129/zuiderheide.html).

## Fonts

These are primarily installed via a pkg manager.

Console: [Inconsolata](http://www.levien.com/type/myfonts/inconsolata.html)
Interface: [DejaVu Sans](https://en.wikipedia.org/wiki/DejaVu_fonts)

## Grub Theme

Based on Manjaro's but modded to match bg image and dark/gray style.
