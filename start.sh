#!/bin/bash
##
## Start up script for Plex Media Server on CentOS docker container
##

## Initialise any variables being called:
# Set the correct timezone
TZ=${TZ:-UTC}
setup=/config/plexmediaserver/.setup
PMS_RPM=$PMS_RPM

if [ ! -f "${setup}" ]; then
  rm -f /etc/localtime
  cp /usr/share/zoneinfo/$TZ /etc/localtime
  yum install -y $PMS_RPM
  yum clean all
  touch $setup
fi

/usr/bin/test -d "/var/lib/plexmediaserver" || /bin/mkdir -p "/var/lib/plexmediaserver"
chown -R plex:plex /var/lib/plexmediaserver

# Bind mount the Plex Media Server var volume that can contain a lot of data
mount --bind /data/plex /var/lib/plexmediaserver

## Start up Plex Media Server daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
