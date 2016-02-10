FROM debian:jessie
MAINTAINER John Gedeon <js1@gedeons.com>

# let debian know we are not interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get -yq install curl php5 php5-cli php5-cgi php5-mysql sudo \
    apache2 libapache2-mod-php5 mysql-client msmtp msmtp-mta ruby && \
  gem install daemons faraday

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Install wp-cli
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

RUN rm /var/www/html/index.html
RUN chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html
RUN runuser -u www-data -- /usr/local/bin/wp core download

# add utilities
COPY bin/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
# COPY lib/* /usr/local/lib/
# RUN /usr/local/bin/update_wp_config.sh

# COPY msmtprc.ini /usr/local/etc/php/conf.d/
# COPY templates /templates
RUN mkdir /database-backups

VOLUME ["/database-backups", "/var/www/html/wp-content"]

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["apachectl -DFOREGROUND"]
