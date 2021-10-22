#! /usr/bin/env bash

DIRECTORY='/opt/Qt'
if [ ! -d "$DIRECTORY" ]
then
    tue-install-pipe wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run -O /tmp/qt-open-source-installer
    tue-install-pipe chmod +x /tmp/qt-open-source-installer

    tue-install-tee ""
    tue-install-echo "Choose $DIRECTORY as install directory!"
    tue-install-tee ""

    tue-install-pipe sudo /tmp/qt-open-source-installer
fi

# Shortcut
if [ -f ~/.local/share/applications/org.qt-project.qtcreator.desktop ] && ! grep -qi tue_robotics ~/.local/share/applications/org.qt-project.qtcreator.desktop
then
    tue-install-debug "Creating back-up of QtCreator desktop file"
    tue-install-pipe mv -f ~/.local/share/applications/org.qt-project.qtcreator.desktop ~/.local/share/applications/org.qt-project.qtcreator.desktop.bk
fi

tue-install-cp shortcut/org.qt-project.qtcreator.desktop ~/.local/share/applications/org.qt-project.qtcreator.desktop
