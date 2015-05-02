# osx-launchd-env

Import environment variables for launchd (includes GUI app from dock) from your shell.

## Description

Apps executed by launchd and GUI apps from dock are can't get your environment variables.
Some apps like `MacVim.app` or `Eclipse.app` expects environment variables exist, though.

From Mac OS X Yosemite (10.10), `launchd.conf` does not work (See `man 5 launchd.conf`).

So we have only one way to define environment variables for launchd: using `launchctl setenv` command.

This scripts simply do it by getting environment variables from `env` command in your login shell and call `launchctl setenv`.

## Usage

Just execute `install.sh` from your shell.
Then logout and login.

## Files

`install.sh` creates a file `~/Library/LaunchAgents/osx-launchd-env.plist`.

This file defines a job called when login that executing `setenv.sh` in clone of this repository.

## Configuration

* `conf/whitelist` defines whitelist of environment keys. If this file is not exist or empty, all variables will be exported.
* `conf/blacklist` defines blacklist of environment keys. If this file is not exist or empty, all variables will be exported.

The order of evaluation is first whitelist, next blacklist. If you define same key in whitelist and blacklist, the variable will not be exported.

## Note

* When you changed login shell, execute `install.sh` again.
* When you edited your rc files, do logout and login or execute `setenv.sh`.
* Now we can't clean unused variables because `launchctl export` does not work (See #1). `launchctl setenv` command saves variables permanently. To remove variables, we have to call `launchctl unsetenv` manually.
