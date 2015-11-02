FROM wordpress:4.3
MAINTAINER John Gedeon <js1@gedeons.com>

# let debian know we are not interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -yq install msmtp msmtp-mta ruby && \
    gem install daemons faraday

# setup root
USER root

# add utilities
COPY bin/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
COPY lib/* /usr/local/lib/
RUN /usr/local/bin/update_wp_config.sh

COPY msmtprc.ini /usr/local/etc/php/conf.d/
COPY templates /templates

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["apache2-foreground"]

# Download wp-cli
# RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Install wp-cli
# RUN mv wp-cli.phar /bin/wp
# RUN chmod +x /bin/wp
