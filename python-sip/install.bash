#! /usr/bin/env bash

# This entire file is temp

SIP_version="4.15.5"

if [ "$(lsb_release -sc)" == "trusty" ]
then
    cucr-install-debug "Skipping, because Trusty"
    return 0
fi

if ! command -v sip >/dev/null 2>&1
then
    # No SIP installed, so also nothing to remove
    cucr-install-debug "No SIP found, so nothing to remove"
    return 0
fi

# We have SIP, let check its version
SIP_installed=$(sip -V)
if [[ "$SIP_installed" == "$SIP_version" ]]
then
    # SIP looks to be installed manually, remove it. So the debian version will be used
    cucr-install-debug "Removing SIP version ($SIP_version), so debian version will be used"
    sudo rm -f /usr/bin/sip >/dev/null
    sudo rm -f /usr/include/python2.7/sip.h >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.so >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.pyi >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipconfig.py >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipdistutils.py >/dev/null
    cucr-install-debug "Removing SIP finished"
    cucr-install-debug "Re-installing SIP from debian"
    cucr-install-debug "sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall"
    sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall
    cucr-install-debug "Debian SIP restored"
else
    cucr-install-debug "SIP installed by debian"
fi
