# Base on latest CentOS image
FROM centos:latest

MAINTAINER “Jon Ervine” <jon.ervine@gmail.com>
ENV container docker

# Install updates and some dev tools
RUN yum update -y
RUN yum clean all

VOLUME /plex-library
VOLUME /data

EXPOSE 1900 32400 32410 32412 32469
ENTRYPOINT ["/usr/sbin/start.sh"]
