FROM shimaore/freeswitch

MAINTAINER Stéphane Alnet <stephane@shimaore.net>

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  curl \
  git \
  make \
  supervisor
# Install Node.js using `n`.
RUN git clone https://github.com/tj/n.git
WORKDIR n
RUN make install
WORKDIR ..
RUN n io 1.7.1
ENV NODE_ENV production

RUN mkdir -p /opt/thinkable-ducks
WORKDIR /opt/thinkable-ducks
COPY . /opt/thinkable-ducks
RUN chown -R freeswitch.freeswitch .
USER freeswitch
RUN mkdir -p \
  conf \
  log
RUN npm install

CMD ["supervisord","-n"]
