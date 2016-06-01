FROM debian:jessie
MAINTAINER Saïd Bouras <said.bouras@gmail.com>

ENV \
    DEBIAN_FRONTEND=noninteractive \
    S6_OVERLAY_VERSION=1.17.1.2 \
    CAKEBOX_VERSION=1.8.6

RUN set -x \
    # Install packages
    && apt-get update \
    && BUILD_DEPS="curl git npm" \
    && apt-get install -y --no-install-recommends \
           $BUILD_DEPS \
           ca-certificates \
           php5-cli \
           php5-curl \
           php5-fpm \
           php5-json \
    && ln -s $(which nodejs) /usr/bin/node \
    && npm install -g \
           bower \
    && curl -sL "https://getcomposer.org/installer" | php -- --install-dir=/usr/bin \
    && mv /usr/bin/composer.phar /usr/bin/composer \

    # Install cakebox
    && rm -rf /var/www/* \
    && git clone https://github.com/Cakebox/cakebox /root/var/www/cakebox \
    && git -C /root/var/www/cakebox checkout v$CAKEBOX_VERSION \
    && sh -c "cd /root/var/www/cakebox && composer install --no-dev --optimize-autoloader" \
    && sh -c "cd /root/var/www/cakebox && bower --allow-root install"

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

    # Clean
RUN apt-get remove -y --purge \
           $BUILD_DEPS \
    && apt-get autoremove -y --purge \
    && find . -type d -name ".git" | xargs rm -rf \
    && rm -rf \
           /root/.cache \
           /root/.config \
           /root/.composer \
           /root/.local \
           /root/.npm \
           /tmp/* \
           /usr/bin/composer \
           /usr/bin/node \
           /usr/local/lib/* \
           /var/lib/apt/lists/* \
           /var/www/.git \
           /var/www/html

# Configure php5-fpm
RUN (sed -i "s@/var/run/php5-fpm.sock@127.0.0.1:7777@g" /etc/php5/fpm/pool.d/www.conf) \
    && (sed -i "s@;listen.mode@listen.mode@g" /etc/php5/fpm/pool.d/www.conf)

COPY ./root/etc /etc/
COPY ./root/cakebox /root/etc/nginx/sites-available/cakebox
COPY ./root/default.php /root/var/www/cakebox/config/default.php

ENTRYPOINT [ "/init" ]
