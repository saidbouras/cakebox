#!/usr/bin/with-contenv /bin/sh

if [ "$(ls -A /var/www/cakebox)" ]; then
     echo "Do nothing, we want to persist files !"
else
    # Set permissions
    cp -R /root/var/www/cakebox/* /var/www/cakebox/
    chown -R www-data:www-data /var/www/cakebox/
    chown -R www-data:www-data ${CAKEBOX_ROOT}
    chmod 775 ${CAKEBOX_ROOT}

    # Configure
    sed -i "s@%CAKEBOX_ROOT%@${CAKEBOX_ROOT:-"/var/www/cakebox/"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%CAKEBOX_ACCESS%@${CAKEBOX_ACCESS:-"/access/"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%CAKEBOX_LANGUAGE%@${CAKEBOX_LANGUAGE:-"en"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%DIRECTORY_IGNORE_DOTFILES%@${DIRECTORY_IGNORE_DOTFILES:-"TRUE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%DIRECTORY_IGNORE%@${DIRECTORY_IGNORE:-"//"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%PLAYER_DEFAULT_TYPE%@${PLAYER_DEFAULT_TYPE:-"html5"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%PLAYER_AUTO_PLAY%@${PLAYER_AUTO_PLAY:-"FALSE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%RIGHTS_CAN_PLAY_MEDIA%@${RIGHTS_CAN_PLAY_MEDIA:-"TRUE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%RIGHTS_CAN_DOWNLOAD_FILE%@${RIGHTS_CAN_DOWNLOAD_FILE:-"TRUE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%RIGHTS_CAN_ARCHIVE_DIRECTORY%@${RIGHTS_CAN_ARCHIVE_DIRECTORY:-"FALSE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%RIGHTS_CAN_DELETE%@${RIGHTS_CAN_DELETE:-"FALSE"}@g" /var/www/cakebox/config/default.php
    sed -i "s@%BETASERIES_LOGIN%@${BETASERIES_LOGIN:-""}@g" /var/www/cakebox/config/default.php
    sed -i "s@%BETASERIES_PASSWORD%@${BETASERIES_PASSWORD:-""}@g" /var/www/cakebox/config/default.php
    sed -i "s@%BETASERIES_API_KEY%@${BETASERIES_API_KEY:-""}@g" /var/www/cakebox/config/default.php

fi

exit 0
