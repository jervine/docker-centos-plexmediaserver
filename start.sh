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

mount --bind /data/plex/media /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Media
mount --bind /data/plex/metadata /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Metadata
mount --bind /data/plex/sync /var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Cache/Transcode/Sync

PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application\ Support
Environment=PLEX_MEDIA_SERVER_HOME=/usr/lib/plexmediaserver
Environment=PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
Environment=PLEX_MEDIA_SERVER_TMPDIR=/tmp
Environment=LD_LIBRARY_PATH=/usr/lib/plexmediaserver
Environment=LC_ALL=en_US.UTF-8
Environment=LANG=en_US.UTF-8
/usr/bin/test -d "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}" || /bin/mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}"

## Start up Plex Media Server daemon via supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf
