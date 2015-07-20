## Assumes that the plexmediaserver.conf ld.so.conf.d file is in place
ldconfig
## Next step should not be necessary as supervisor daemon should already set to this directory
cd /var/lib/plexmediaserver
## Run the Plex Media Server daemon
/usr/lib/plexmediaserver/Plex\ Media\ Server
