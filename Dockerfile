FROM lgohr/squid-alpine

ENV DESTINATION=google.de

RUN apk add --no-cache jq
COPY reverseproxy.sh /home/squid/reverseproxy.sh
ENTRYPOINT /home/squid/reverseproxy.sh

EXPOSE 80/tcp
