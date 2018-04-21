#!/usr/bin/env sh

set -xe

OS=`uname -s`
THEME=mako
opt=$1

INST_PATH=/usr/share

ICONS_PATH=$INST_PATH/icons/$THEME
THEMES_PATH="$INST_PATH/themes/$THEME"
BG_IMG_PATH="$INST_PATH/backgrounds/$THEME.png"
ICONS_EXTRA_PATH=$INST_PATH/icons/$THEME-extra
CURSOR_URL="https://www.opendesktop.org/p/999946/startdownload?file_id=1463061628&file_name=28427-simpleandsoft-0.2.tar.gz&file_type=application/x-gzip&file_size=34793&url=https%3A%2F%2Fdl.opendesktop.org%2Fapi%2Ffiles%2Fdownloadfile%2Fid%2F1463061628%2Fs%2F6b49b8ec0e53089ade8b58be5effff32%2Ft%2F1524424510%2Fu%2F26968%2F28427-simpleandsoft-0.2.tar.gz"
TMP_PATH=/tmp/$THEME
PACKAGER="" # set in check_packager()

FONT_TITLE="DejaVu Sans 10"
FONT_MONO="Inconsolata 12"
FONT_INTERFACE="DejaVu Sans 10"
FONT_DOCUMENT="DejaVu Sans 12"

APT_PKGS=(
  sassc
  nodejs
  curl
  libglib2.0-dev
  gnome-common
  gnome-shell-extensions
  gnome-tweak-tool
  libxml2-utils
  gtk2-engines-murrine
  gtk2-engines-pixbuf
  git
  fonts-dejavu
  fonts-inconsolata
)

DNF_PKGS=(
  curl
  nodejs
  gnome-common
  gnome-tweak-tool
  gnome-shell-extension-user-theme
  glib2-devel
  gtk-murrine-engine
  gtk2-engines
  git
  sassc
  dejavu-sans-fonts
  levien-inconsolata-fonts
)

ZYP_PKGS=(
  curl
  nodejs
  gnome-common
  gnome-tweak-tool
  gtk2-engine-murrine
  gtk2-engines
  git
  sassc
  glib2-devel
  dejavu-fonts
  google-inconsolata-fonts
  gnome-tweaks
)

PAC_PKGS=(
  curl
  nodejs
  sassc
  glib2
  gnome-shell-extensions
  gnome-common
  gtk-engine-murrine
  gtk-engines
  git
  ttf-inconsolata
  ttf-dejavu
  gnome-tweaks
)

YUM_PKGS=(
  curl
  nodejs
  ruby
  glib2-devel
  gnome-common
  gnome-tweak-tool
  gnome-shell-extension-user-theme
  git
  dejavu-sans-fonts
)

BRW_PKGS=(
  git
  font-inconsolata
  font-dejavu
)

as_root() {
  if [ $(id -u) -eq 0 ]; then
    "$@"
  else
    if [ ! -z $(command -v sudo) ]; then
      sudo "$@"
    elif [ ! -z $(command -v su) ]; then
      su root -c "$@"
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
      as_root yaourt --noconfirm -S ${PAC_PKGS[@]}
      ;;
    zypper)
      as_root zypper in -y ${ZYP_PKGS[@]}
      ;;
    dnf)
      as_root dnf install -y ${DNF_PKGS[@]}
      ;;
    yum)
      as_root yum install -y ${YUM_PKGS[@]}
      ;;
    apt)
      as_root apt install -y ${APT_PKGS[@]}
      ;;
    brew)
      as_root brew tap caskroom/fonts
      as_root brew install -y ${BRW_PKGS[@]}
      ;;
    *)
      echo "WARNING: Can't install fonts, etc. Unknown pkg manager."
      ;;
  esac

  if [ -z $(command -v sassc) ]; then
    as_root gem install rake sassc

    if [ ! -x sassc ]; then
      as_root ln -s `which sass` /usr/bin/sassc
    fi
  fi
}

install_icons() {
  cd icons/vertex-icons
  as_root mkdir -p $ICONS_PATH
  as_root cp -r * $ICONS_PATH
  as_root sed -i "s/Name=.*/Name=$THEME-icons/" "$ICONS_PATH/index.theme"
  as_root sed -i "s/Inherits=.*/Inherits=$THEME-icons-extra/" "$ICONS_PATH/index.theme"
  git reset HEAD --hard
  cd - > /dev/null

  cd icons/paper-icon-theme
  as_root mkdir -p $TMP_PATH/icons
  ./autogen.sh --prefix=$TMP_PATH/icons
  make
  sudo make install > /dev/null
  as_root cp -r $TMP_PATH/icons/share/icons/Paper $ICONS_EXTRA_PATH
  as_root rm -rf $TMP_PATH/icons/share/icons/Paper*
  as_root sed -i "s/Name=.*/Name=$THEME-icons-extra/" $ICONS_EXTRA_PATH/index.theme
  as_root sed -i "s/Inherits=.*/Inherits=gnome,hicolor/" $ICONS_EXTRA_PATH/index.theme
  git reset HEAD --hard
  cd - > /dev/null
}

install_gtk_theme() {
  THEME_COLOURS="<(echo -e BG=d8d8d8\nFG=101010\nMENU_BG=3c3c3c\nMENU_FG=e6e6e6\nSEL_BG=ad7fa8\nSEL_FG=ffffff\nTXT_BG=ffffff\nTXT_FG=1a1a1a\nBTN_BG=f5f5f5\nBTN_FG=111111\n)"

  cd themes/materia-theme
  # TODO
  #./change_color.sh -o $THEME "$THEME_COLOURS"
  as_root ./install.sh -g -d $INST_PATH/themes -n $THEME -c standard -s compact
  as_root mv $INST_PATH/themes/mako-compact $THEMES_PATH

  as_root sed -i "s/Name=.*/Name=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/GtkTheme=.*/GtkTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/MetacityTheme=.*/MetacityTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/IconTheme=.*/IconTheme=$THEME/" "$THEMES_PATH/index.theme"
  as_root sed -i "s/CursorTheme=.*/CursorTheme=$THEME-cursor/" "$THEMES_PATH/index.theme"
  cd - > /dev/null

  as_root cp bg/bg.png $BG_IMG_PATH
}

install_cursor_theme() {
  ARCHIVE_NAME="Simple-and-Soft.tar.gz"
  CURSOR_INST_DIR="$INST_PATH/icons/$THEME-cursor"

  curl -fsL "$CURSOR_URL" > cursors/$ARCHIVE_NAME
  cd cursors
  tar -xvf "$ARCHIVE_NAME"
  cd - > /dev/null

  as_root cp -r cursors/simpleandsoft $CURSOR_INST_DIR
  as_root cp cursors/index.theme $CURSOR_INST_DIR

  rm cursors/$ARCHIVE_NAME
  rm -r cursors/simpleandsoft
}

install_grub_theme() {
  if [ -x update-grub ]; then
    as_root cp -r boot/grub $INST_PATH/grub/themes/$THEME
    as_root cp /etc/default/grub /etc/default/grub.bak
    as_root sed -i 's/\#?GRUB_THEME.*/GRUB_THEME=\"/usr/share/grub/themes/mako/theme.txt"/' /etc/default/grub
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

  GNOME_USR_THEME_EXT="user-theme@gnome-shell-extensions.gcampax.github.com"
  NEW_SETTINGS=$(node -e "console.log(JSON.stringify($(gsettings get org.gnome.shell enabled-extensions).concat('$GNOME_USR_THEME_EXT')))")
  gsettings set org.gnome.shell enabled-extensions "$NEW_SETTINGS"
  gsettings set org.gnome.shell.extensions.user-theme name "$THEME"
  gsettings set org.gnome.desktop.interface gtk-theme "$THEME"
  gsettings set org.gnome.desktop.interface icon-theme "$THEME"
  gsettings set org.gnome.desktop.interface cursor-theme "$THEME-cursor"
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
  rm -r ~/.config/gtk-2.0
  rm -r ~/.config/gtk-3.0
  rm -r ~/.config/gtk-4.0
  as_root rm -rf $INST_PATH/icons/mako*
  as_root rm -rf $INST_PATH/themes/mako*
  as_root rm -rf $INST_PATH/backgrounds/mako*
  as_root rm /etc/dconf/db/gdm.d/10-cursor-settings
}

install() {
  check_packager
  install_pkgs
  checkout_submodules

  if [ "$OS" = "Linux" ]; then
    install_icons
    install_gtk_theme
    install_cursor_theme
    install_grub_theme
    install_config
  fi
}

uninstall() {
  remove_files

  if [ -f /etc/default/grub.bak ]; then
    as_root mv /etc/default/grub.bak /etc/default/grub
    as_root update-grub
  fi

  # TODO: does this actually work as expected?
  gsettings set org.gnome.shell enabled-extensions ""
  gsettings set org.gnome.shell.extensions.user-theme ""
  gsettings set org.gnome.desktop.interface gtk-theme ""
  gsettings set org.gnome.desktop.interface icon-theme ""
  gsettings set org.gnome.desktop.interface cursor-theme ""
  gsettings set org.gnome.desktop.background picture-uri ""
  gsettings set org.gnome.desktop.screensaver picture-uri ""
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
      ;;
    * )
      install
      ;;
  esac
}

trap clean_tmp EXIT

run
