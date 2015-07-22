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

/usr/bin/test -d "/var/lib/plexmediaserver/Library/Application Support" || /bin/mkdir -p "/var/lib/plexmediaserver/Library/Application Support"
/usr/bin/test -d "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media" || /bin/mkdir -p "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media"
/usr/bin/test -d "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Metadata" || /bin/mkdir -p "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Metadata"
/usr/bin/test -d "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/Transcode/Sync" || /bin/mkdir -p "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/Transcode/Sync"
chown -R plex:plex /var/lib/plexmediaserver

# Bind mount the volumes that contain a lot of data
mount --bind /data/plex/media /var/lib/plexmediaserver/Library/Application Support/Plex\ Media\ Server/Media
mount --bind /data/plex/metadata /var/lib/plexmediaserver/Library/Application Support/Plex\ Media\ Server/Metadata
mount --bind /data/plex/sync /var/lib/plexmediaserver/Library/Application Support/Plex\ Media\ Server/Cache/Transcode/Sync

## Start up Plex Media Server daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
