FROM ubuntu:20.04 AS build

RUN apt-get update && apt-get install -y build-essential libffi-dev perl zlib1g-dev curl

RUN curl -fsLO https://dl.duosecurity.com/duoauthproxy-latest-src.tgz

RUN tar -xzvf duoauthproxy-latest-src.tgz && \
  cd $(ls -d */ | grep duoauthproxy) && \
  make

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y expect

RUN echo '#!/usr/bin/expect -f' > /install_script && \
  echo 'set env(TERM) vt100' >> /install_script && \
  echo 'set env(SHELL) /bin/bash' >> /install_script && \
  echo 'set env(HOME) /root' >> /install_script && \
  echo 'set timeout -1' >> /install_script && \
  echo "spawn /$(ls -d */ | grep duoauthproxy)duoauthproxy-build/install" >> /install_script && \
  echo 'expect "] "' >> /install_script && \
  echo 'send -- "\n"' >> /install_script && \
  echo 'expect "] "' >> /install_script && \
  echo 'send -- "\n"' >> /install_script && \
  echo 'expect "] "' >> /install_script && \
  echo 'send -- "\n"' >> /install_script && \
  echo 'expect "] "' >> /install_script && \
  echo 'send -- "\n"' >> /install_script && \
  echo 'expect ".cfg"' >> /install_script && \
  chmod +x /install_script && \
  find / -type f > ~/before.txt && \
  /install_script && \
  find / -type f > ~/after.txt

FROM curlimages/curl AS curl

USER root

RUN curl -fsLo /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 && \
  chmod +x /tini

FROM ubuntu:20.04

COPY --from=curl /tini /usr/local/bin/

COPY --from=build /etc/passwd /etc/gshadow /etc/shadow /etc/group /etc/

COPY --from=build /etc/init.d/duoauthproxy /etc/init.d/

COPY --from=build /opt/duoauthproxy /opt/duoauthproxy

COPY docker-entrypoint.sh /

VOLUME ["/opt/duoauthproxy/log"]

ENTRYPOINT ["tini", "/docker-entrypoint.sh"]
