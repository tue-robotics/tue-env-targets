#! /usr/bin/env bash

# This entire file is temp

SIP_version="4.15.5"

if [ "$(lsb_release -sc)" == "trusty" ]
then
    tue-install-debug "Skipping, because Trusty"
    return 0
fi

if ! command -v sip >/dev/null 2>&1
then
    # No SIP installed, so also nothing to remove
    tue-install-debug "No SIP found, so nothing to remove"
    return 0
fi

# We have SIP, let check its version
SIP_installed=$(sip -V)
if [[ "$SIP_installed" == "$SIP_version" ]]
then
    # SIP looks to be installed manually, remove it. So the debian version will be used
    tue-install-debug "Removing SIP version ($SIP_version), so debian version will be used"
    sudo rm -f /usr/bin/sip >/dev/null
    sudo rm -f /usr/include/python2.7/sip.h >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.so >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sip.pyi >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipconfig.py >/dev/null
    sudo rm -f /usr/lib/python2.7/dist-packages/sipdistutils.py >/dev/null
    tue-install-debug "Removing SIP finished"
    tue-install-debug "Re-installing SIP from debian"
    tue-install-debug "sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall"
    sudo apt-get install -qq python-sip python-sip-dev sip-dev --reinstall
    tue-install-debug "Debian SIP restored"
else
    tue-install-debug "SIP installed by debian"
fi
