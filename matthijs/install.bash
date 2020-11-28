#! /usr/bin/env bash

# Git Settings
git_config_items="pull.ff=true color.ui=always merge.tool=meld"
for item in $git_config_items
do
        option=${item%=*}
        value=${item#*=}
        irohms-install-debug "git config --global --replace-all $option $value"
        git config --global --replace-all "$option" "$value"
done

# Gnome scroll windows (all ubuntu versions newer than xenial(16.04))
if [ "$(lsb_release -sc)" != "xenial" ]
then
    gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
fi

# Shortcuts
# PyCharm
irohms-install-cp shortcuts/pycharm-professional_pycharm-professional.desktop ~/.local/share/applications/pycharm-professional_pycharm-professional.desktop
# Terminator
irohms-install-cp shortcuts/terminator.desktop ~/.local/share/applications/terminator.desktop

# Qt Creator
if [ -f ~/.local/share/applications/org.qt-project.qtcreator.desktop ] && ! grep -qi matthijs ~/.local/share/applications/org.qt-project.qtcreator.desktop
then
    mv -f ~/.local/share/applications/org.qt-project.qtcreator.desktop ~/.local/share/applications/org.qt-project.qtcreator.desktop.bk
fi
irohms-install-cp shortcuts/org.qt-project.qtcreator.desktop ~/.local/share/applications/org.qt-project.qtcreator.desktop

# WhatsApp
irohms-install-cp shortcuts/whatsapp-webapp.desktop ~/.local/share/applications/whatsapp-webapp.desktop
irohms-install-cp shortcuts/icons/whatsapp.svg /usr/share/icons/hicolor/scalable/apps/whatsapp.svg
