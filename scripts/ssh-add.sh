#!/bin/sh
export SSH_ASKPASS=/usr/bin/ksshaskpass
/usr/bin/ssh-add $HOME/.ssh/$(hostname)_ed25519 </dev/null
