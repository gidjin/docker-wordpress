FROM wordpress:4.3
MAINTAINER John Gedeon <js1@gedeons.com>

COPY update_wp_config.sh /tmp/
RUN chmod a+x /tmp/update_wp_config.sh && /tmp/update_wp_config.sh

# Download wp-cli
# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Install wp-cli
# RUN mv wp-cli.phar /bin/wp
# RUN chmod +x /bin/wp
