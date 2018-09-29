FROM alpine
LABEL maintainer="larsgohr@gmail.com"

ENV CACHE_DIR=/var/spool/squid \
    LOG_DIR=/var/log/squid \
    DESTINATION=google.de

RUN apk add --no-cache squid \
  jq

RUN mkdir -p ${LOG_DIR} \
  && chmod -R 755 ${LOG_DIR} \
  && chown -R squid ${LOG_DIR} \
  && mkdir -p ${CACHE_DIR} \
  && chmod -R 755 ${LOG_DIR} \
  && chown -R squid ${CACHE_DIR} \
  && echo "pid_filename /var/run/squid/squid.pid" >> /etc/squid/squid.conf

COPY reverseproxy.sh /home/squid/reverseproxy.sh
ENTRYPOINT /home/squid/reverseproxy.sh
EXPOSE 80/tcp
USER squid
ENTRYPOINT ["/home/squid/reverseproxy.sh"]
