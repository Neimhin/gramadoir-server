FROM ubuntu:18.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y less wget
RUN apt-get install -y build-essential
RUN apt-get install -y liblingua-ga-gramadoir-perl
RUN apt-get install -y libdatetime-perl
RUN apt-get install -y libjson-perl
RUN apt-get install -y libencode-perl
RUN apt-get install -y liblog-dispatch-filerotate-perl
RUN apt-get install -y libdancer2-perl

# COPY gramadoir-server-cache.pl /usr/bin/gramadoir-server
# RUN chmod +x /usr/bin/gramadoir