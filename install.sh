#!/usr/bin/env sh
OS=`uname -s`
THEME=mako
opt=$1

INST_PATH=/usr/share

ICONS_PATH=$INST_PATH/icons/$THEME
THEMES_PATH="$INST_PATH/themes/$THEME"
BG_IMG_PATH="$INST_PATH/backgrounds/$THEME.png"
ICONS_EXTRA_PATH=$INST_PATH/icons/$THEME-icons-extra
CURSOR_URL="https://www.archlinux.org/packages/community/any/xcursor-vanilla-dmz/download/"
TMP_PATH=/tmp/$THEME
PACKAGER="" # set in check_packager()

FONT_TITLE="DejaVu Sans 10"
FONT_MONO="Inconsolata 12"
FONT_INTERFACE="DejaVu Sans 10"
FONT_DOCUMENT="DejaVu Sans 12"

APT_PKGS="curl nodejs inkscape autoconf ruby ruby-sass ruby-dev libglib2.0-dev gnome-themes-standard gnome-common gnome-shell-extensions gnome-tweak-tool libxml2-utils gtk2-engines-murrine gtk2-engines-pixbuf git fonts-dejavu fonts-inconsolata"
DNF_PKGS="curl nodejs inkscape gnome-common gnome-tweak-tool gnome-shell-extension-user-theme glib2-devel gtk-murrine-engine gtk2-engines git sassc dejavu-sans-fonts levien-inconsolata-fonts"
ZYP_PKGS="curl make inkscape autoconf gcc gcc-c++ ruby2.1 ruby-devel nodejs6 gnome-common gnome-tweak-tool gtk2-engine-murrine gtk2-engines git glib2-devel dejavu-fonts google-inconsolata-fonts"
PAC_PKGS="curl nodejs inkscape sassc glib2 gnome-themes-extra gnome-shell-extensions gnome-common gtk-engine-murrine gtk-engines git ttf-inconsolata ttf-dejavu gnome-tweaks"
YUM_PKGS="curl nodejs inkscape epel-release ruby gcc-c++ glib2-devel gnome-common gnome-tweak-tool gnome-shell-extension-user-theme git dejavu-sans-fonts"
BRW_PKGS="git font-inconsolata font-dejavu"

as_root() {
  echo "sudo \"$@\""
  if [ $(id -u) -eq 0 ]; then
    "$@"
  else
    if [ ! -z $(command -v sudo) ]; then
      sudo "$@"
    elif [ ! -z $(command -v su) ]; then
      su root -c "$*"
    else
      echo "Can't continue without sudo/su installed." && exit 1
    fi
  fi
}

check_packager() {
  if [ ! -z "$(command -v pacman)" ]; then
    PACKAGER="pacman"
  elif [ ! -z "$(command -v zypper)" ]; then
    PACKAGER="zypper"
  elif [ ! -z "$(command -v dnf)" ]; then
    PACKAGER="dnf"
  elif [ ! -z "$(command -v yum)" ]; then
    PACKAGER="yum"
  elif [ ! -z "$(command -v apt)" ]; then
    PACKAGER="apt"
  elif [ "$OS" = "Darwin" ] && [ ! -z "$(command -v brew)" ]; then
    PACKAGER="brew"
  fi
}

install_pkgs() {
  case $PACKAGER in
    pacman)
      as_root pacman --noconfirm -S yaourt
      as_root yaourt --noconfirm -S $PAC_PKGS
      ;;
    zypper)
      as_root zypper in -y $ZYP_PKGS
      ;;
    dnf)
      as_root dnf install -y $DNF_PKGS
      ;;
    yum)
      curl --silent --location https://rpm.nodesource.com/setup_8.x | as_root bash -
      as_root yum -y install $YUM_PKGS
      ;;
    apt)
      as_root apt -y install $APT_PKGS
      ;;
    brew)
      as_root brew tap caskroom/fonts
      as_root brew install -y $BRW_PKGS
      # TODO: copy over bg image
      # TODO: can set via cmdline?
      ;;
    *)
      echo "WARNING: Can't install fonts, etc. Unknown pkg manager."
      ;;
  esac

  if [ -z $(command -v node) ]; then
    as_root ln -fs /usr/bin/nodejs /usr/bin/node
  fi

  if [ -z $(command -v sassc) ]; then
    as_root gem install -f rake sassc

    if [ -z $(command -v sassc) ]; then
      if [ -z $(command -v sass) ]; then
        # HACK: openSUSE
        as_root ln -fs /usr/bin/sass.ruby2.1 /usr/bin/sassc
      else
        as_root ln -fs $(which sass) /usr/bin/sassc
      fi
    fi
  fi
}

install_icons() {
  cd icons/vertex-icons
  as_root mkdir -p $ICONS_PATH
  as_root cp -r * $ICONS_PATH
  as_root sed -i "s/Name=.*/Name=$THEME/" "$ICONS_PATH/index.theme"
  as_root sed -i "s/Inherits=.*/Inherits=$THEME-icons-extra,gnome,hicolor/" "$ICONS_PATH/index.theme"
  git reset HEAD --hard
  cd - > /dev/null

  cd icons/paper-icon-theme
  as_root mkdir -p $TMP_PATH/icons
  ./autogen.sh --prefix=$TMP_PATH/icons
  make
  as_root make install > /dev/null
  as_root cp -r $TMP_PATH/icons/share/icons/Paper $ICONS_EXTRA_PATH
  as_root rm -rf $TMP_PATH/icons/share/icons/Paper*
  as_root sed -i "s/Name=.*/Name=$THEME-icons-extra/" $ICONS_EXTRA_PATH/index.theme
  as_root sed -i "s/Inherits=.*/Inherits=Adwaita,gnome,hicolor/" $ICONS_EXTRA_PATH/index.theme
  git reset HEAD --hard
  cd - > /dev/null
}

install_gtk_theme() {
  THEME_COLOURS="../preset.txt"

  cd themes/materia-theme

  mkdir -p $HOME/.themes

  # HACK: using sudo :-S
  git checkout -- change_color.sh
  sed -i "s/^\.\/install\.sh/sudo \.\/install.sh \-g/g" change_color.sh
  ./change_color.sh -o $THEME-tmp $THEME_COLOURS
  as_root cp -rf $HOME/.themes/$THEME-tmp $THEMES_PATH
  as_root rm -rf $HOME/.themes/$THEME-tmp
  as_root sed -i "s/Name=.*/Name=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/GtkTheme=.*/GtkTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/MetacityTheme=.*/MetacityTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/IconTheme=.*/IconTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/CursorTheme=.*/CursorTheme=$THEME/" "$THEMES_PATH/index.theme"

  cd - > /dev/null

  if [ ! -d /usr/share/backgrounds ]; then
    as_root mkdir -p /usr/share/backgrounds
  fi
  as_root cp images/background.png $BG_IMG_PATH
}

install_cursor_theme() {
  ARCHIVE_NAME="xcursor-dmz.tar.gz"
  CURSOR_INST_DIR="$INST_PATH/icons/$THEME"
  CURSOR_DL_PATH=cursors
  CURSOR_EXTRACTED_PATH=usr/share/icons/Vanilla-DMZ

  mkdir -p $CURSOR_DL_PATH
  curl -fL "$CURSOR_URL" > $CURSOR_DL_PATH/$ARCHIVE_NAME
  cd $CURSOR_DL_PATH
  tar -xvf "$ARCHIVE_NAME" > /dev/null
  cd - > /dev/null

  as_root cp -r $CURSOR_DL_PATH/$CURSOR_EXTRACTED_PATH/cursors $CURSOR_INST_DIR/cursors
  rm -rf $CURSOR_DL_PATH
}

install_grub_theme() {
  DEFAULT_GRUB_FILE=/etc/default/grub
  if [ ! -z "$(command -v update-grub)" ]; then
    as_root mkdir -p $INST_PATH/grub/themes
    as_root cp -r boot/grub $INST_PATH/grub/themes/$THEME
    as_root cp -f $DEFAULT_GRUB_FILE $DEFAULT_GRUB_FILE.bak
    # TODO: check if setting already exists and replace vs adding on (ex: manjaro linux)
    echo 'GRUB_THEME="/usr/share/grub/themes/mako/theme.txt"' | as_root tee -a $DEFAULT_GRUB_FILE
    as_root sed -i 's/GRUB_HIDDEN_TIMEOUT_QUIET.*//' $DEFAULT_GRUB_FILE
    as_root sed -i 's/GRUB_HIDDEN_TIMEOUT.*//' $DEFAULT_GRUB_FILE
    as_root sed -i 's/GRUB_TIMEOUT.*/GRUB_TIMEOUT=5/' $DEFAULT_GRUB_FILE
    as_root sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT.*/GRUB_CMDLINE_LINUX_DEFAULT=""/' $DEFAULT_GRUB_FILE
    as_root update-grub
  fi
}

install_config() {
  mkdir -p ~/.config/gtk-2.0
  mkdir -p ~/.config/gtk-3.0
  mkdir -p ~/.config/gtk-4.0
  cp config/gtk-settings.ini ~/.config/gtk-2.0
  cp config/gtk-settings.ini ~/.config/gtk-3.0
  cp config/gtk-settings.ini ~/.config/gtk-4.0

  as_root mkdir -p /etc/dconf/db/gdm.d
  as_root cp -f config/10-cursor-settings /etc/dconf/db/gdm.d/10-cursor-settings
  as_root cp -f config/icons-default-index.theme /usr/share/icons/default/index.theme

  GNOME_USR_THEME_EXT="user-theme\@gnome-shell-extensions.gcampax.github.com"
  ENABLED_EXTS=$(gsettings get org.gnome.shell enabled-extensions | sed 's/\@as\s*//')
  NEW_SETTINGS=$(node -e "console.log(JSON.stringify($ENABLED_EXTS.concat('$GNOME_USR_THEME_EXT')))")
  gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
  gsettings set org.gnome.desktop.background show-desktop-icons "false"
  gsettings set org.gnome.shell enabled-extensions "$NEW_SETTINGS"
  gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  gsettings set org.gnome.desktop.interface icon-theme "$THEME"
  gsettings set org.gnome.desktop.interface cursor-theme "$THEME"
  gsettings set org.gnome.desktop.background picture-uri "$BG_IMG_PATH"
  gsettings set org.gnome.desktop.screensaver picture-uri "$BG_IMG_PATH"
  gsettings set org.gnome.desktop.wm.preferences titlebar-font "$FONT_TITLE"
  gsettings set org.gnome.desktop.interface font-name "$FONT_INTERFACE"
  gsettings set org.gnome.desktop.interface document-font-name "$FONT_DOCUMENT"
  if [ ! $PACKAGER = "yum" ]; then
    gsettings set org.gnome.desktop.interface monospace-font-name "$FONT_MONO"
  fi
}

clean_tmp() {
  if [ -d $TMP_PATH ]; then
    as_root rm -rf $TMP_PATH
  fi
}

checkout_submodules() {
  git submodule update --init
}

remove_files() {
  rm -rf ~/.config/gtk-2.0
  rm -rf ~/.config/gtk-3.0
  rm -rf ~/.config/gtk-4.0
  as_root rm -rf $INST_PATH/icons/mako*
  as_root rm -rf $INST_PATH/themes/mako*
  as_root rm -rf $INST_PATH/backgrounds/mako*
  as_root rm -f /etc/dconf/db/gdm.d/10-cursor-settings
}

install() {
  echo "== Installing packages"
  check_packager
  install_pkgs
  echo "== Checkout submodules"
  checkout_submodules

  if [ "$OS" = "Linux" ]; then
    echo "== Installing icon packs"
    install_icons
    echo "== Installing gtk theme"
    install_gtk_theme
    echo "== Installing cursor theme"
    install_cursor_theme
    echo "== Installing grub theme"
    install_grub_theme
    echo "== Configuring install"
    install_config
  fi
}

uninstall() {
  remove_files

  if [ -f /etc/default/grub.bak ]; then
    as_root mv /etc/default/grub.bak /etc/default/grub
    as_root rm -rf $INST_PATH/grub/themes/$THEME
    as_root update-grub
  fi

  # before turning off user themes..
  gsettings reset org.gnome.shell.extensions.user-theme name

  # don't reset enabled extensions until we have prev list
  gsettings reset org.gnome.desktop.input-sources xkb-options
  gsettings reset org.gnome.desktop.background show-desktop-icons
  gsettings reset org.gnome.desktop.interface gtk-theme
  gsettings reset org.gnome.desktop.interface icon-theme
  gsettings reset org.gnome.desktop.interface cursor-theme
  gsettings reset org.gnome.desktop.background picture-uri
  gsettings reset org.gnome.desktop.screensaver picture-uri
  gsettings reset org.gnome.desktop.wm.preferences titlebar-font
  gsettings reset org.gnome.desktop.interface font-name
  gsettings reset org.gnome.desktop.interface document-font-name
  gsettings reset org.gnome.desktop.interface monospace-font-name
}

usage() {
  echo "install [-h] [--revert]"
  echo "  => install or uninstall (with --revert)";
}

run() {
  case $opt in
    -h )
      usage
      exit 0
      ;;
    --revert )
      uninstall
      trap clean_tmp EXIT
      ;;
    * )
      install
      trap clean_tmp EXIT
      ;;
  esac
  echo "== Done! (you may have to restart)"
}

run
