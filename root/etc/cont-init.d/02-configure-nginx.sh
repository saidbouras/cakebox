#!/usr/bin/with-contenv /bin/sh

cp /root/etc/nginx/sites-available/cakebox /etc/nginx/sites-available/cakebox

sed -i "s@alias /var/www/cakebox@alias ${CAKEBOX_ROOT:-"/var/www/cakebox"}@g" /etc/nginx/sites-available/cakebox
sed -i "s@%SERVER_NAME%@${SERVER_NAME:-"localhost"}@g" /etc/nginx/sites-available/cakebox

# Disable the default server used when only docker nginx is up
unlink /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/cakebox /etc/nginx/sites-enabled/cakebox

# Check if .htpasswd presents
if [ -e ${CAKEBOX_ROOT}/.htpasswd ]; then
    cp ${CAKEBOX_ROOT}/.htpasswd /var/www/cakebox/public/ \
    && chmod 755 /var/www/cakebox/public/.htpasswd \
    && chown www-data:www-data /var/www/cakebox/public/.htpasswd
else
    # disable basic auth
    sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/sites-available/cakebox
fi

exit 0