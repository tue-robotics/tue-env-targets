#! /usr/bin/env bash

# This entire file is temp

SIP_version="4.15.5"

if [ "$(lsb_release -sc)" == "trusty" ]
then
    irohms-install-debug "Skipping, because Trusty"
    return 0
fi

if ! command -v sip >/dev/null 2>&1
then
    # No SIP installed, so also nothing to remove
    irohms-install-debug "No SIP found, so nothing to remove"
    return 0
fi

# We have SIP, let check its version
SIP_installed=$(sip -V)
if [[ "$SIP_installed" == "$SIP_version" ]]
then
    # SIP looks to be installed manually, remove it. So the debian version will be used
    irohms-install-debug "Removing SIP version ($SIP_version), so debian version will be used"
    sudo rm -f /usr/bin/sip >/dev/null
    sudo rm -f /usr/include/python2.7/sip.h >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.so >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.pyi >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipconfig.py >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipdistutils.py >/dev/null
    irohms-install-debug "Removing SIP finished"
    irohms-install-debug "Re-installing SIP from debian"
    irohms-install-debug "sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall"
    sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall
    irohms-install-debug "Debian SIP restored"
else
    irohms-install-debug "SIP installed by debian"
fi
