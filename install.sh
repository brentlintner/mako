#!/usr/bin/env sh

# check arch to not do stuff on macOS

cd themes/vimix
...
cd -

cd icons/paper-icon-theme
./autogen.sh
make
sudo make install
# change the folder name?
cd -
# install vertex-icons
cd ...
# cp -r /usr/share/.icons/.

# install cursor theme
# cp -r /usr/share/icons

# install grub theme
# cp -r /usr/share/grub themes
# run update grub?

# install fonts

# ubuntu
# fonts-dejavu
# fonts-inconsolata

# arch
# ttf-dejavu
# ttf-inconsolata

# fedora
# dnf install ttf-dejavu
# dnf install levien-inconsolata-fonts.noarch

# mac os (https://github.com/caskroom/homebrew-fonts)
# brew tap caskroom/fonts
# brew cask install flont-inconsolata

# install gtk/ files to appropriate place
