FROM lgohr/squid-alpine

ENV DESTINATION=google.de

USER root
RUN apk add --no-cache jq
COPY reverseproxy.sh /home/squid/reverseproxy.sh
ENTRYPOINT /home/squid/reverseproxy.sh
USER squid

EXPOSE 80/tcp
