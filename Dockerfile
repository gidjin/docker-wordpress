FROM tutum/wordpress-stackable:latest
MAINTAINER John Gedeon <js1@gedeons.com>

# let debian know we are not interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -yq install mysql-client curl msmtp msmtp-mta \
    cron curl gnupg build-essential

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN echo "US/Pacific" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN bash -l -c "rvm install 2.2.3 \
  && rvm info \
  && gem install bundler daemons faraday whenever"

# setup root
USER root

WORKDIR /

ENV WORDPRESS_VERSION 4.3.1
ENV WORDPRESS_SHA1 b2e5652a6d2333cabe7b37459362a3e5b8b66221

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C / \
  && rm wordpress.tar.gz \
  && cp -av /wordpress /app \
  && chown -R www-data:www-data /app

# add utilities
COPY schedule.rb /schedule.rb
COPY bin/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
COPY lib/* /usr/local/lib/
RUN /usr/local/bin/update_wp_config.sh

COPY msmtprc.ini /etc/php5/apache2/conf.d/
COPY msmtprc.ini /etc/php5/cli/conf.d/
COPY templates /templates

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/init.sh"]
