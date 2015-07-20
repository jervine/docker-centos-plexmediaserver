# Base on latest CentOS image
FROM centos:latest

MAINTAINER “Jon Ervine” <jon.ervine@gmail.com>
ENV container docker

# Install updates and some dev tools
RUN yum install -y http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN yum install -y supervisor
RUN yum update -y
RUN yum clean all

ADD supervisord.conf /etc/supervisord.conf
ADD plexmediaserver.ini /etc/supervisord.d/plexmediaserver.ini
ADD start.sh /usr/sbin/start.sh
RUN chmod 755 /usr/sbin/start.sh

VOLUME /plex-library
VOLUME /data

EXPOSE 1900 9001 32400 32410 32412 32469
ENTRYPOINT ["/usr/sbin/start.sh"]
