FROM wordpress:4.3
MAINTAINER John Gedeon <js1@gedeons.com>

RUN apt-get update && apt-get -yq install msmtp msmtp-mta ruby

COPY update_wp_config.sh /tmp/
COPY msmtprc_generator.rb /usr/local/bin/
COPY msmtprc.ini /usr/local/etc/php/conf.d/
COPY init.sh /init.sh
COPY templates /templates
RUN chmod a+x /tmp/update_wp_config.sh && /tmp/update_wp_config.sh
RUN chmod a+x /usr/local/bin/msmtprc_generator.rb
RUN chmod a+x /init.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/init.sh"]
CMD ["apache2-foreground"]

# Download wp-cli
# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Install wp-cli
# RUN mv wp-cli.phar /bin/wp
# RUN chmod +x /bin/wp
