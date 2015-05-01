#!/bin/bash

set -u

# remove old plist
if [[ -f ~/Library/LaunchAgents/osx-launchd-env.plist ]]; then
    rm -f ~/Library/LaunchAgents/osx-launchd-env.plist
fi

# get login shell
login_shell="`dscl localhost -read Local/Default/Users/$USER UserShell | cut -d' ' -f2`"

# get current directory
cwd=$(cd $(dirname $0) && pwd)

# put plist
cp $cwd/osx-launchd-env.plist ~/Library/LaunchAgents

# replace placeholders
/usr/bin/sed -i '' \
    -e "s!{{ SHELL }}!$login_shell!" \
    -e "s!{{ SETENV }}!$cwd/setenv.sh!" \
    ~/Library/LaunchAgents/osx-launchd-env.plist
