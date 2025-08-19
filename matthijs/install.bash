#! /usr/bin/env bash

# Git Settings
git_config_items="advice.skippedCherryPicks=false color.ui=always merge.tool=meld pull.ff=true rebase.autoStash=true rebase.updateRefs=true rerere.enabled=true url.ssh://git@github.com/.insteadOf=https://github.com/"
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
    tue-install-debug "gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'"
    gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows'
    gsettings set org.gnome.shell.extensions.ding show-trash true
    gsettings set org.gnome.shell.extensions.ding show-home false
fi

# Styling
themes_path=~/src/vimix-gtk-themes
tue-install-git https://github.com/vinceliuice/vimix-gtk-themes.git --target-dir=$themes_path
themes_commit_hash=$(git -C "$themes_path" rev-list HEAD -n 1)
if [ ! -f $themes_path/last_install ] || [ "$(cat "$themes_path"/last_install)" != "$themes_commit_hash" ]
then
    tue-install-debug "Installing vimix-gtk-themes"
    tue-install-pipe $themes_path/install.sh -c standard -t ruby -s compact --tweaks flat grey
    echo "$themes_commit_hash" > $themes_path/last_install
else
    tue-install-debug "vimix-gtk-themes not updated"
fi

icon_path=~/src/vimix-icon-theme
tue-install-git https://github.com/vinceliuice/vimix-icon-theme.git --target-dir=$icon_path
icon_commit_hash=$(git -C "$icon_path" rev-list HEAD -n 1)
if [ ! -f $icon_path/last_install ] || [ "$(cat "$icon_path"/last_install)" != "$icon_commit_hash" ]
then
    tue-install-debug "Installing vimix-icon-theme"
    tue-install-pipe $icon_path/install.sh
    echo "$icon_commit_hash" > $icon_path/last_install
else
    tue-install-debug "vimix-icon-theme not updated"
fi

# Shortcuts
# Terminator
tue-install-cp shortcuts/terminator.desktop ~/.local/share/applications/terminator.desktop

# Configs
if [ "$(lsb_release -sc)" != "focal" ]
then
    tue-install-cp configs/gammastep.ini "${XDG_CONFIG_HOME:-~/.config}"/gammastep/config.ini
fi
tue-install-cp configs/99-beacondb.conf /etc/geoclue/conf.d/99-beacondb.conf
