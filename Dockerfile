FROM alpine:3.10

ARG FACEBOOK=1
ARG STEAM=1
ARG SKYPEWEB=1
ARG TELEGRAM=1
ARG HANGOUTS=1
ARG SLACK=1
ARG SIPE=1
ARG DISCORD=1
ARG ROCKETCHAT=1
ARG MASTODON=1
ARG MATRIX=1

ENV BITLBEE_VERSION 3.6
ENV FACEBOOK_VERSION v1.2.0
ENV STEAM_VERSION a6444d2
ENV SKYPEWEB_VERSION 5d29285
ENV TELEGRAM_VERSION b101bbb
ENV HANGOUTS_VERSION 3f7d89b
ENV SLACK_VERSION 8acc4eb
ENV SIPE_VERSION upstream/1.23.3
ENV DISCORD_VERSION aa0bbf2
ENV ROCKETCHAT_VERSION 826990b
ENV MASTODON_VERSION 83dee0b
ENV OLM_VERSION 3.1.4
ENV MATRIX_VERSION 4494ba2

RUN addgroup -g 101 -S bitlbee \
 && adduser -u 101 -D -S -G bitlbee bitlbee \
 && apk add --no-cache --update tzdata \
 	libpurple \
	libpurple-xmpp \
	libpurple-oscar \
	libpurple-bonjour \
	json-glib \
	libgcrypt \
	libssl1.1 \
	libcrypto1.1 \
	gettext \
	libwebp \
	glib \
	protobuf-c \
	discount-libs \
	libpng \
	sqlite \
	http-parser \
	bash \
 && apk add --no-cache --update --virtual .build-dependencies \
	git \
	make \
	autoconf \
	automake \
	libtool \
	gcc \
	g++ \
	json-glib-dev \
	libgcrypt-dev \
	openssl-dev \
	pidgin-dev \
	libwebp-dev \
	glib-dev \
	protobuf-c-dev \
	mercurial \
	libxml2-dev \
	discount-dev \
	libpng-dev \
	sqlite-dev \
	http-parser-dev \
 && cd /tmp \
 && git clone https://github.com/bitlbee/bitlbee.git \
 && cd bitlbee \
 && git checkout ${BITLBEE_VERSION} \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --purple=1 --ssl=openssl --prefix=/usr --etcdir=/etc/bitlbee \
 && make \
 && make install \
 && make install-dev \
 && if [ ${FACEBOOK} -eq 1 ]; then cd /tmp \
 && git clone https://github.com/bitlbee/bitlbee-facebook.git \
 && cd bitlbee-facebook \
 && git checkout ${FACEBOOK_VERSION} \
 && ./autogen.sh \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/facebook.so; fi \
 && if [ ${STEAM} -eq 1 ]; then cd /tmp \
 && git clone https://github.com/bitlbee/bitlbee-steam.git \
 && cd bitlbee-steam \
 && git checkout ${STEAM_VERSION} \
 && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/steam.so; fi \
 && if [ ${SKYPEWEB} -eq 1 ]; then cd /tmp \
 && git clone git://github.com/EionRobb/skype4pidgin.git \
 && cd skype4pidgin/skypeweb \
 && git checkout ${SKYPEWEB_VERSION} \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libskypeweb.so; fi \
 && if [ ${TELEGRAM} -eq 1 ]; then cd /tmp \
 && git clone --recursive https://github.com/majn/telegram-purple \
 && cd telegram-purple \
 && git checkout ${TELEGRAM_VERSION} \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/purple-2/telegram-purple.so; fi \
 && if [ ${HANGOUTS} -eq 1 ]; then cd /tmp \
 && hg clone https://bitbucket.org/EionRobb/purple-hangouts -r ${HANGOUTS_VERSION} \
 && cd purple-hangouts \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libhangouts.so; fi \
 && if [ ${SLACK} -eq 1 ]; then cd /tmp \
 && git clone https://github.com/dylex/slack-libpurple.git \
 && cd slack-libpurple \
 && git checkout ${SLACK_VERSION} \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libslack.so; fi \
 && if [ ${SIPE} -eq 1 ]; then cd /tmp \
 && git clone https://github.com/tieto/sipe.git \
 && cd sipe \
 && git checkout ${SIPE_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libsipe.so; fi \
 && if [ ${DISCORD} -eq 1 ]; then cd /tmp \
 && git clone https://github.com/sm00th/bitlbee-discord.git \
 && cd bitlbee-discord \
 && git checkout ${DISCORD_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/discord.so; fi \
 && if [ ${ROCKETCHAT} -eq 1 ]; then cd /tmp \
 && hg clone https://bitbucket.org/EionRobb/purple-rocketchat -r ${ROCKETCHAT_VERSION} \
 && cd purple-rocketchat \
 && make \
 && make install \
 && strip /usr/lib/purple-2/librocketchat.so; fi \
 && if [ ${MASTODON} -eq 1 ]; then cd /tmp \
 && git clone -n https://github.com/kensanata/bitlbee-mastodon \
 && cd bitlbee-mastodon \
 && git checkout ${MASTODON_VERSION} \
 && ./autogen.sh \
 && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
 && make \
 && make install \
 && strip /usr/lib/bitlbee/mastodon.so; fi \
 && if [ ${MATRIX} -eq 1 ]; then cd /tmp \
 && git clone -n https://gitlab.matrix.org/matrix-org/olm.git \
 && cd olm \
 && git checkout ${OLM_VERSION} \
 && make \
 && make install \
 && cd /tmp \
 && git clone -n https://github.com/matrix-org/purple-matrix \
 && cd purple-matrix \
 && git checkout ${MATRIX_VERSION} \
 && make \
 && make install \
 && strip /usr/lib/purple-2/libmatrix.so; fi \
 && rm -rf /tmp/* \
 && rm -rf /usr/include/bitlbee \
 && rm -f /usr/lib/pkgconfig/bitlbee.pc \
 && apk del .build-dependencies

EXPOSE 6667

USER bitlbee

CMD [ "/usr/sbin/bitlbee", "-F", "-n" ]
