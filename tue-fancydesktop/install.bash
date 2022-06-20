#! /usr/bin/env bash

# copying shortcuts to desktop
cucr-install-cp shortcuts/.*.desktop ~/Desktop
if [ ! -f ~/.local/share/applications/AMIGO\ Dashboard.desktop ]
then
    cucr-install-cp shortcuts/.*.desktop ~/.local/share/applications/
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.Terminator/Terminator/' '{}' \;
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.AMIGO/AMIGO/' '{}' \;
    find ~/.local/share/applications/ -iname ".*.desktop" -exec rename 's/\.SERGIO/SERGIO/' '{}' \;
fi

# copying shortcuts to desktop
cucr-install-cp icons/*.png /usr/share/pixmaps/cucr/

# copying terminator config file
[ -f ~/.config/terminator/config ] && cp ~/.config/terminator/config ~/.config/terminator/configbackup
cucr-install-cp configs/terminator/config ~/.config/terminator/config


# copying variety config file
[ -f ~/.config/variety/variety.conf ] && cp ~/.config/variety/variety.conf ~/.config/variety/variety.conf.backup
cucr-install-cp configs/variety/variety.conf ~/.config/variety/variety.conf
