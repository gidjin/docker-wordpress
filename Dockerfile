FROM phusion/passenger-customizable:0.9.14
MAINTAINER John Gedeon <js1@gedeons.com>

# Set correct environment variables.
ENV HOME /root

# install basics
RUN /build/utilities.sh

CMD ["/sbin/my_init"]

# install ruby 2.1
RUN /build/ruby2.1.sh

# Install apache, mysql-client, and php
RUN apt-get update && apt-get -yq install mysql-client-5.6 \
  apache2 apache2-bin apache2-data apache2-mpm-prefork apache2-utils \
  libapache2-mod-php5 libapr1 libaprutil1 libdbd-mysql-perl \
  libdbi-perl libnet-daemon-perl libplrpc-perl libpq5 php5-common php5-mysql \
  msmtp msmtp-mta

# Add permalink feature
RUN a2enmod rewrite

# Setup for running on port 80
EXPOSE 80

# Expose environment variables
ENV DATABASE_HOST **LinkMe**
ENV DATABASE_PORT **LinkMe**
ENV DATABASE_NAME wordpress
ENV DATABASE_USER admin
ENV DATABASE_PASS **ChangeMe**
# Main site url for aliases define ALIAS_URL using comma separated values if more than one alias
ENV MAIN_URL **ChangeMe**
ENV SITE_TITLE "Just some site"
ENV SITE_ADMIN_USER admin
ENV SITE_ADMIN_PASS **ChangeMe**
ENV SITE_ADMIN_EMAIL **ChangeMe**

# Download wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Install wp-cli
RUN mv wp-cli.phar /bin/wp
RUN chmod +x /bin/wp

# Clear out default site
RUN mkdir /var/www/wordpress
RUN chown www-data:www-data /var/www/wordpress

# Install my_init.d startup scripts
COPY my_init.d/* /etc/my_init.d/
RUN chmod 755 /etc/my_init.d/*
# Install tempates
COPY templates /templates
COPY wordpress.conf /etc/apache2/sites-enabled/000-default.conf

# Download latest wordpress code
RUN sudo -u www-data /bin/wp core --path=/var/www/wordpress download --version=4.0.1

# Setup main volume
VOLUME ["/var/www/wordpress"]

# Clean up apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
