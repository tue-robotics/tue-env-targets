#! /usr/bin/env bash

# Geany config
if [ ! -f ~/.config/geany/geany.conf ]
then
    tue-install-debug "geany config not existing"
    mkdir -p ~/.config/geany
    tue-install-cp geany.conf ~/.config/geany/geany.conf
else
    tue-install-debug "geany config does exists, so not copying matthijs config"
fi

# Git Settings
git_config_items="pull.ff=true color.ui=always merge.tool=meld"
for item in $git_config_items
do
        option=${item%=*}
        value=${item#*=}
        tue-install-debug "git config --global --replace-all $option $value"
        git config --global --replace-all "$option" "$value"
done

# Gnome scroll windows (all ubuntu versions newer than xenial(16.04))
if [ "$(lsb_release -sc)" != "xenial" ]
then
    gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
fi

# Shortcuts
tue-install-cp shortcuts/pycharm-community.desktop ~/Desktop
tue-install-cp shortcuts/qtcreator.desktop ~/Desktop
tue-install-cp shortcuts/terminator.desktop /usr/share/applications

tue-install-cp shortcuts/whatsapp-webapp.desktop /usr/share/applications
tue-install-cp shortcuts/icons/whatsapp.svg /usr/share/icons/hicolor/scalable/apps
