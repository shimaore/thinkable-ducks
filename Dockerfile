#
# This is not meant to be a runnable image.
# This will only work after you install your own
# package in /opt/thinkable-ducks (see README.md).
#

FROM shimaore/freeswitch:2.1.4
MAINTAINER Stéphane Alnet <stephane@shimaore.net>
ENV NODE_ENV production

USER root
RUN \
  mkdir -p /opt/thinkable-ducks/{conf,log} && \
  chown -R freeswitch.freeswitch /opt/thinkable-ducks/ && \
  apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    make \
    python-pkg-resources \
    supervisor \
  && \
# Install Node.js using `n`.
  git clone https://github.com/tj/n.git n.git && \
  cd n.git && \
  make install && \
  cd .. && \
  rm -rf n.git && \
  n 4.3.2 && \
  apt-get purge -y \
    build-essential \
    ca-certificates \
    cpp-5 \
    gcc-5 \
    curl \
    git \
    make \
  && \
  apt-get autoremove -y && apt-get clean

WORKDIR /opt/thinkable-ducks
USER freeswitch
COPY supervisord.conf.src /opt/thinkable-ducks/
COPY supervisord.conf.sh /opt/thinkable-ducks/
CMD ["/opt/thinkable-ducks/supervisord.conf.sh"]
