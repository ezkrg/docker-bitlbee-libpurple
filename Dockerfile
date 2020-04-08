FROM alpine:3.10 as bitlbee-build

ARG BITLBEE_VERSION=3.6

RUN apk add --no-cache --update \
	bash shadow build-base git python2 autoconf automake libtool mercurial intltool flex \
	glib-dev openssl-dev pidgin-dev json-glib-dev libgcrypt-dev zlib-dev libwebp-dev \
	libpng-dev protobuf-c-dev libxml2-dev discount-dev sqlite-dev http-parser-dev \
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
 && touch /nowhere

# ---

FROM bitlbee-build as facebook-build

ARG FACEBOOK=1
ARG FACEBOOK_VERSION=v1.2.0

RUN if [ ${FACEBOOK} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/bitlbee/bitlbee-facebook.git \
	   && cd bitlbee-facebook \
	   && git checkout ${FACEBOOK_VERSION} \
	   && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
	   && make \
	   && make install \
	   && strip /usr/lib/bitlbee/facebook.so; \
	 else mkdir -p /usr/lib/bitlbee \
 	   && ln -sf /nowhere /usr/lib/bitlbee/facebook.so \
	   && ln -sf /nowhere /usr/lib/bitlbee/facebook.la; \
	fi

# ---

FROM bitlbee-build as steam-build

ARG STEAM=1
ARG STEAM_VERSION=a6444d2

RUN if [ ${STEAM} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/bitlbee/bitlbee-steam.git \
	   && cd bitlbee-steam \
	   && git checkout ${STEAM_VERSION} \
	   && ./autogen.sh --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
	   && make \
	   && make install \
	   && strip /usr/lib/bitlbee/steam.so; \
	 else mkdir -p /usr/lib/bitlbee \
	   && ln -sf /nowhere /usr/lib/bitlbee/steam.so \
	   && ln -sf /nowhere /usr/lib/bitlbee/steam.la; \
	fi

# ---

FROM bitlbee-build as skypeweb-build

ARG SKYPEWEB=1
ARG SKYPEWEB_VERSION=5d29285

RUN if [ ${SKYPEWEB} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/EionRobb/skype4pidgin.git \
	   && cd skype4pidgin \
	   && git checkout ${SKYPEWEB_VERSION} \
	   && cd skypeweb \
	   && make \
	   && make install \
	   && strip /usr/lib/purple-2/libskypeweb.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/libskypeweb.so; \
	fi

# ---

FROM bitlbee-build as telegram-build

ARG TELEGRAM=1
ARG TELEGRAM_VERSION=v1.4.3

RUN if [ ${TELEGRAM} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/majn/telegram-purple \
	   && cd telegram-purple \
	   && git checkout ${TELEGRAM_VERSION} \
	   && git submodule update --init --recursive \
	   && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
	   && make \
	   && make install \
	   && strip /usr/lib/purple-2/telegram-purple.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/telegram-purple.so \
	   && ln -sf /nowhere /etc/telegram-purple \
	   && ln -sf /nowhere /usr/local/share/locale; \
	fi

# ---

FROM bitlbee-build as hangouts-build

ARG HANGOUTS=1
ARG HANGOUTS_VERSION=3f7d89b

RUN if [ ${HANGOUTS} -eq 1 ]; \
	 then cd /tmp \
	   && hg clone https://bitbucket.org/EionRobb/purple-hangouts -r ${HANGOUTS_VERSION} \
	   && cd purple-hangouts \
	   && make \
	   && make install \
	   && strip /usr/lib/purple-2/libhangouts.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/libhangouts.so; \
	fi

# ---

FROM bitlbee-build as slack-build

ARG SLACK=1
ARG SLACK_VERSION=e6e5427

SHELL [ "/bin/bash", "-c" ]

RUN if [ ${SLACK} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/dylex/slack-libpurple.git \
	   && cd slack-libpurple \
	   && git checkout ${SLACK_VERSION} \
	   && make \
	   && install -d /usr/share/pixmaps/pidgin/protocols/{16,22,48} \
	   && make install \
	   && strip /usr/lib/purple-2/libslack.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/libslack.so; \
	fi

# ---

FROM bitlbee-build as sipe-build

ARG SIPE=1
ARG SIPE_VERSION=1.25.0

RUN if [ ${SIPE} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://repo.or.cz/siplcs.git \
	   && cd siplcs \
	   && git checkout ${SIPE_VERSION} \
	   && ./autogen.sh \
	   && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
	   && make \
	   && make install \
	   && strip /usr/lib/purple-2/libsipe.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/libsipe.so \
	   && ln -sf /nowhere /usr/lib/purple-2/libsipe.la \
	   && ln -sf /nowhere /usr/share/locale; \
	fi

# ---

FROM bitlbee-build as discord-build

ARG DISCORD=1
ARG DISCORD_VERSION=0.4.3

RUN if [ ${DISCORD} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/sm00th/bitlbee-discord.git \
	   && cd bitlbee-discord \
	   && git checkout ${DISCORD_VERSION} \
	   && ./autogen.sh \
	   && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl --prefix=/usr \
	   && make \
	   && make install \
	   && strip /usr/lib/bitlbee/discord.so; \
	 else mkdir -p /usr/lib/bitlbee \
	   && ln -sf /nowhere /usr/lib/bitlbee/discord.so \
	   && ln -sf /nowhere /usr/lib/bitlbee/discord.la \
	   && ln -sf /nowhere /usr/share/bitlbee/discord-help.txt; \
	fi

# ---

FROM bitlbee-build as rocketchat-build

ARG ROCKETCHAT=1
ARG ROCKETCHAT_VERSION=826990b

RUN if [ ${ROCKETCHAT} -eq 1 ]; \
	 then cd /tmp \
	   && hg clone https://bitbucket.org/EionRobb/purple-rocketchat -r ${ROCKETCHAT_VERSION} \
	   && cd purple-rocketchat \
	   && make \
	   && make install \
	   && strip /usr/lib/purple-2/librocketchat.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/lib/purple-2/librocketchat.so; \
	fi

# ---

FROM bitlbee-build as mastodon-build

ARG MASTODON=1
ARG MASTODON_VERSION=v1.4.4

RUN if [ ${MASTODON} -eq 1 ]; \
	 then cd /tmp \
	   && git clone -n https://github.com/kensanata/bitlbee-mastodon \
	   && cd bitlbee-mastodon \
	   && git checkout ${MASTODON_VERSION} \
	   && sh ./autogen.sh \
	   && ./configure --build=x86_64-alpine-linux-musl --host=x86_64-alpine-linux-musl \
	   && make \
	   && make install \
	   && strip /usr/lib/bitlbee/mastodon.so; \
	 else mkdir -p /usr/lib/bitlbee \
	   && ln -sf /nowhere /usr/lib/bitlbee/mastodon.so \
	   && ln -sf /nowhere /usr/lib/bitlbee/mastodon.la \
	   && ln -sf /nowhere /usr/share/bitlbee/mastodon-help.txt; \
	fi

# ---

FROM bitlbee-build as matrix-build

ARG MATRIX=1
ARG OLM_VERSION=3.1.4
ARG MATRIX_VERSION=1d23385

RUN if [ ${MATRIX} -eq 1 ]; \
	 then cd /tmp \
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
	   && strip /usr/lib/purple-2/libmatrix.so; \
	 else mkdir -p /usr/lib/purple-2 \
	   && ln -sf /nowhere /usr/local/lib/libolm.so.3.1.4 \
	   && ln -sf /nowhere /usr/lib/purple-2/libmatrix.so; \
	fi

# ---

FROM alpine:3.10 as bitlbee-plugins

COPY --from=bitlbee-build /usr/sbin/bitlbee /tmp/usr/sbin/bitlbee
COPY --from=bitlbee-build /usr/share/man/man8/bitlbee.8 /tmp/usr/share/man/man8/bitlbee.8
COPY --from=bitlbee-build /usr/share/man/man5/bitlbee.conf.5 /tmp/usr/share/man/man5/bitlbee.conf.5
COPY --from=bitlbee-build /usr/share/bitlbee /tmp/usr/share/bitlbee
COPY --from=bitlbee-build /usr/lib/pkgconfig/bitlbee.pc /tmp/usr/lib/pkgconfig/bitlbee.pc
COPY --from=bitlbee-build /etc/bitlbee /tmp/etc/bitlbee

COPY --from=facebook-build /usr/lib/bitlbee/facebook.so /tmp/usr/lib/bitlbee/facebook.so
COPY --from=facebook-build /usr/lib/bitlbee/facebook.la /tmp/usr/lib/bitlbee/facebook.la

COPY --from=steam-build /usr/lib/bitlbee/steam.so /tmp/usr/lib/bitlbee/steam.so
COPY --from=steam-build /usr/lib/bitlbee/steam.la /tmp/usr/lib/bitlbee/steam.la

COPY --from=skypeweb-build /usr/lib/purple-2/libskypeweb.so /tmp/usr/lib/purple-2/libskypeweb.so

COPY --from=telegram-build /usr/lib/purple-2/telegram-purple.so /tmp/usr/lib/purple-2/telegram-purple.so
COPY --from=telegram-build /etc/telegram-purple /tmp/etc/telegram-purple
COPY --from=telegram-build /usr/local/share/locale /tmp/usr/local/share/locale

COPY --from=hangouts-build /usr/lib/purple-2/libhangouts.so /tmp/usr/lib/purple-2/libhangouts.so

COPY --from=slack-build /usr/lib/purple-2/libslack.so /tmp/usr/lib/purple-2/libslack.so

COPY --from=sipe-build /usr/lib/purple-2/libsipe.so /tmp/usr/lib/purple-2/libsipe.so
COPY --from=sipe-build /usr/lib/purple-2/libsipe.la /tmp/usr/lib/purple-2/libsipe.la
COPY --from=sipe-build /usr/share/locale /tmp/usr/share/locale

COPY --from=discord-build /usr/lib/bitlbee/discord.so /tmp/usr/lib/bitlbee/discord.so
COPY --from=discord-build /usr/lib/bitlbee/discord.la /tmp/usr/lib/bitlbee/discord.la
COPY --from=discord-build /usr/share/bitlbee/discord-help.txt /tmp/usr/share/bitlbee/discord-help.txt

COPY --from=rocketchat-build /usr/lib/purple-2/librocketchat.so /tmp/usr/lib/purple-2/librocketchat.so

COPY --from=mastodon-build /usr/lib/bitlbee/mastodon.so /tmp/usr/lib/bitlbee/mastodon.so
COPY --from=mastodon-build /usr/lib/bitlbee/mastodon.la /tmp/usr/lib/bitlbee/mastodon.la
COPY --from=mastodon-build /usr/share/bitlbee/mastodon-help.txt /tmp/usr/share/bitlbee/mastodon-help.txt

COPY --from=matrix-build /usr/local/lib/libolm.so.3.1.4 /tmp/usr/local/lib/libolm.so.3
COPY --from=matrix-build /usr/lib/purple-2/libmatrix.so /tmp/usr/lib/purple-2/libmatrix.so

RUN apk add --update --no-cache findutils \
 && find /tmp/ -type f -empty -delete \
 && find /tmp/ -type d -empty -delete

# ---

FROM alpine:3.10 as bitlbee-libpurple

COPY --from=bitlbee-plugins /tmp/ /

RUN addgroup -g 101 -S bitlbee \
 && adduser -u 101 -D -S -G bitlbee bitlbee \
 && install -d -m 750 -o bitlbee -g bitlbee /var/lib/bitlbee \
 && apk add --no-cache --update \
 	tzdata bash glib libssl1.1 libpurple libpurple-xmpp \
	libpurple-oscar libpurple-bonjour json-glib libgcrypt zlib \
	libwebp libpng protobuf-c discount sqlite http-parser

EXPOSE 6667

CMD [ "/usr/sbin/bitlbee", "-F", "-n", "-u", "bitlbee" ]
