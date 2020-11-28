#! /usr/bin/env bash

# copying shortcuts to desktop
irohms-install-cp shortcuts/.*.desktop ~/Desktop
if [ ! -f ~/.local/share/applications/AMIGO\ Dashboard.desktop ]
then
    irohms-install-cp shortcuts/.*.desktop ~/.local/share/applications/
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.Terminator/Terminator/' '{}' \;
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.AMIGO/AMIGO/' '{}' \;
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.SERGIO/SERGIO/' '{}' \;
fi

# copying shortcuts to desktop
irohms-install-cp icons/*.png /usr/share/pixmaps/irohms/

# copying terminator config file
[ -f ~/.config/terminator/config ] && cp ~/.config/terminator/config ~/.config/terminator/configbackup
irohms-install-cp configs/terminator/config ~/.config/terminator/config


# copying variety config file
[ -f ~/.config/variety/variety.conf ] && cp ~/.config/variety/variety.conf ~/.config/variety/variety.conf.backup
irohms-install-cp configs/variety/variety.conf ~/.config/variety/variety.conf
