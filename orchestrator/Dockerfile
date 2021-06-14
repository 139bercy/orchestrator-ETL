FROM docker:20.10.6

RUN apk add --no-cache inotify-tools bash && apk add --no-cache --virtual compil postgresql-client git pkgconfig libpq gcc libc-dev postgresql-dev \
  && git clone https://github.com/begriffs/pg_listen.git && cd pg_listen \
  && gcc -Wpedantic -D_POSIX_C_SOURCE=200112L -Wall -Wextra pg_listen.c -lpq -o pg_listen \
  && apk del compil


# RUN adduser -h /home/user -s /bin/bash -D -u 1000 user

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /config
VOLUME /scripts

# WORKDIR /home/user
# USER user

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY run.sh /run.sh
