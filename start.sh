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
  /usr/bin/test -d "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}" || /bin/mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}"
  chown -R plex:plex /var/lib/plexmediaserver
  touch $setup
fi

mount --bind /data/plex/media /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media
mount --bind /data/plex/metadata /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Metadata
mount --bind /data/plex/sync /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/Transcode/Sync

## Start up Plex Media Server daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
