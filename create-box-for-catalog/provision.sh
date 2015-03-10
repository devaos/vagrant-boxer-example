#!/bin/sh
#
# Sample Vagrant provisioner to customize the basic chef/debian-7.4 box
# from Vagrant Cloud and make it your own.
#

cat <<__EOF >/etc/motd

This custom motd just shows that we're running our custom box.
Your provisioner probably does more important stuff.

Version: 1.0.0

__EOF
