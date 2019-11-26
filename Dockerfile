FROM alpine:3.10

ARG BITLBEE_VERSION=3.6

RUN addgroup -g 101 -S bitlbee \
 && adduser -u 101 -D -S -G bitlbee bitlbee \
 && apk add --no-cache --update \
 	tzdata \
	bash \
	glib \
	libssl1.1 \
	libpurple \
	libpurple-xmpp \
	libpurple-oscar \
	libpurple-bonjour \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	glib-dev \
	openssl-dev \
	python2 \
	pidgin-dev \
 && cd /tmp \
 && git clone -n https://github.com/bitlbee/bitlbee.git \
 && cd bitlbee \
 && git checkout ${BITLBEE_VERSION} \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --purple=1 --ssl=openssl --prefix=/usr --etcdir=/etc/bitlbee \
 && make \
 && make install \
 && make install-dev \
 && make install-etc \
 && strip /usr/sbin/bitlbee \
 && rm -rf /tmp/* \
 && apk del .build-dependencies

ARG FACEBOOK=1
ARG FACEBOOK_VERSION=v1.2.0

RUN if [ ${FACEBOOK} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	json-glib \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	autoconf \
	automake \
	libtool \
	glib-dev \
	json-glib-dev \
 && git clone -n https://github.com/bitlbee/bitlbee-facebook.git \
 && cd bitlbee-facebook \
 && git checkout ${FACEBOOK_VERSION} \
 && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/facebook.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG STEAM=1
ARG STEAM_VERSION=a6444d2

RUN if [ ${STEAM} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	libgcrypt \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	autoconf \
	automake \
	libtool \
	libgcrypt-dev \
	glib-dev \
 && git clone -n https://github.com/bitlbee/bitlbee-steam.git \
 && cd bitlbee-steam \
 && git checkout ${STEAM_VERSION} \
 && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/steam.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG SKYPEWEB=1
ARG SKYPEWEB_VERSION=5d29285

RUN if [ ${SKYPEWEB} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	json-glib \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	pidgin-dev \
	json-glib-dev \
 && git clone -n https://github.com/EionRobb/skype4pidgin.git \
 && cd skype4pidgin \
 && git checkout ${SKYPEWEB_VERSION} \
 && cd skypeweb \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libskypeweb.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG TELEGRAM=1
ARG TELEGRAM_VERSION=b101bbb

RUN if [ ${TELEGRAM} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	libgcrypt \
	zlib \
	libwebp \
	libpng \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	libgcrypt-dev \
	zlib-dev \
	pidgin-dev \
	libwebp-dev \
	libpng-dev \
 && git clone -n https://github.com/majn/telegram-purple \
 && cd telegram-purple \
 && git checkout ${TELEGRAM_VERSION} \
 && git submodule update --init --recursive \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/purple-2/telegram-purple.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG HANGOUTS=1
ARG HANGOUTS_VERSION=3f7d89b

RUN if [ ${HANGOUTS} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	protobuf-c \
	json-glib \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	mercurial \
	pidgin-dev \
	protobuf-c-dev \
	json-glib-dev \
 && hg clone https://bitbucket.org/EionRobb/purple-hangouts -r ${HANGOUTS_VERSION} \
 && cd purple-hangouts \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libhangouts.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG SLACK=1
ARG SLACK_VERSION=8acc4eb

RUN if [ ${SLACK} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	pidgin-dev \
	glib-dev \
 && git clone -n https://github.com/dylex/slack-libpurple.git \
 && cd slack-libpurple \
 && git checkout ${SLACK_VERSION} \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libslack.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG SIPE=1
ARG SIPE_VERSION=upstream/1.23.3

RUN if [ ${SIPE} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	libtool \
	glib-dev \
	intltool \
	automake \
	autoconf \
	openssl-dev \
	libxml2-dev \
	pidgin-dev \
 && git clone -n https://github.com/tieto/sipe.git \
 && cd sipe \
 && git checkout ${SIPE_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libsipe.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG DISCORD=1
ARG DISCORD_VERSION=aa0bbf2

RUN if [ ${DISCORD} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	autoconf \
	automake \
	libtool \
	glib-dev \
 && git clone -n https://github.com/sm00th/bitlbee-discord.git \
 && cd bitlbee-discord \
 && git checkout ${DISCORD_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/discord.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG ROCKETCHAT=1
ARG ROCKETCHAT_VERSION=826990b

RUN if [ ${ROCKETCHAT} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	discount \
	json-glib \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	mercurial \
	pidgin-dev \
	json-glib-dev \
	discount-dev \
 && hg clone https://bitbucket.org/EionRobb/purple-rocketchat -r ${ROCKETCHAT_VERSION} \
 && cd purple-rocketchat \
 && make \
 && make install \
 && strip /usr/lib/purple-2/librocketchat.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG MASTODON=1
ARG MASTODON_VERSION=83dee0b

RUN if [ ${MASTODON} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	autoconf \
	automake \
	libtool \
	glib-dev \
 && git clone -n https://github.com/kensanata/bitlbee-mastodon \
 && cd bitlbee-mastodon \
 && git checkout ${MASTODON_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/mastodon.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

ARG MATRIX=1
ARG OLM_VERSION=3.1.4
ARG MATRIX_VERSION=4494ba2

RUN if [ ${MATRIX} -eq 1 ]; then cd /tmp \
 && apk add --no-cache --update \
	sqlite \
	http-parser \
	libgcrypt \
	json-glib \
 && apk add --no-cache --update --virtual .build-dependencies \
	build-base \
	git \
	libgcrypt-dev \
	pidgin-dev \
	json-glib-dev \
	glib-dev \
	sqlite-dev \
	http-parser-dev \
 && git clone -n https://gitlab.matrix.org/matrix-org/olm.git \
 && cd olm \
 && git checkout ${OLM_VERSION} \
 && make \
 && make install \
 && strip /usr/local/lib/libolm.so.${OLM_VERSION} \
 && cd /tmp \
 && git clone -n https://github.com/matrix-org/purple-matrix \
 && cd purple-matrix \
 && git checkout ${MATRIX_VERSION} \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libmatrix.so \
 && rm -rf /tmp/* \
 && apk del .build-dependencies; fi

EXPOSE 6667

USER bitlbee

CMD [ "/usr/sbin/bitlbee", "-F", "-n" ]
