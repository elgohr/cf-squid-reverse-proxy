FROM alpine:3.9.2
LABEL maintainer="larsgohr@gmail.com"

ENV CACHE_DIR=/var/spool/squid \
    LOG_DIR=/var/log/squid \
    DESTINATION=google.de

RUN apk add --no-cache squid jq

COPY reverseproxy.sh /home/squid/reverseproxy.sh
COPY squid.conf /etc/squid/squid.conf

RUN mkdir -p ${LOG_DIR} \
  && chmod -R 755 ${LOG_DIR} \
  && chown -R squid ${LOG_DIR} \
  && mkdir -p ${CACHE_DIR} \
  && chmod -R 755 ${CACHE_DIR} \
  && chown -R squid ${CACHE_DIR} \
  && chown -R squid /etc/squid \
  && setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/squid

USER squid
EXPOSE 80/tcp
ENTRYPOINT ["/home/squid/reverseproxy.sh"]
