#!/bin/bash
##
## Start up script for Plex Media Server on CentOS docker container
##

## Initialise any variables being called:
# Set the correct timezone
TZ=${TZ:-UTC}
setup=/config/plexmediaserver/.setup
PMS-RPM=$PMS-RPM

if [ ! -f "${setup}" ]; then
  rm -f /etc/localtime
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  yum install -y $PMS-RPM
  yum clean all
  touch $setup
fi

mount --bind /data/plex /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media

## Start up Plex Media Server daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
