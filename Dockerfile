#
# This is not meant to be a runnable image.
# This will only work after you install your own
# package in /opt/thinkable-ducks (see README.md).
#

FROM shimaore/freeswitch:4.0.4
MAINTAINER Stéphane Alnet <stephane@shimaore.net>
ENV NODE_ENV production

USER root
RUN \
  mkdir -p /opt/thinkable-ducks/conf /opt/thinkable_ducks/log && \
  chown -R freeswitch.freeswitch /opt/thinkable-ducks/ && \
  apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    make \
    supervisor \
  && \
# Install Node.js using `n`.
  git clone https://github.com/tj/n.git n.git && \
  cd n.git && \
  make install && \
  cd .. && \
  rm -rf n.git && \
  n 6.7.0 && \
  apt-get purge -y \
    ca-certificates \
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
