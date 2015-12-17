FROM tutum/wordpress-stackable:latest
MAINTAINER John Gedeon <js1@gedeons.com>

# let debian know we are not interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -yq install mysql-client curl msmtp msmtp-mta \
    cron curl gnupg build-essential openssh-client ocaml-native-compilers exuberant-ctags inotify-tools

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN echo "US/Pacific" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN bash -l -c "rvm install 2.2.3 \
  && rvm info \
  && gem install bundler daemons faraday whenever"

# setup root
USER root
ENV HOME=/root
WORKDIR /

ENV WORDPRESS_VER 4.3.1
ENV WORDPRESS_SHA1 b2e5652a6d2333cabe7b37459362a3e5b8b66221

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VER}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C / \
  && rm wordpress.tar.gz \
  && cp -av /wordpress /app \
  && chown -R www-data:www-data /app

RUN curl -o unison.tar.gz -SL http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.3.tar.gz \
  && tar -xzf unison.tar.gz -C / \
  && rm unison.tar.gz \
  && cd /unison-2.48.3 \
  && HOME=/usr/local make UISTYLE=text NATIVE=true install \
  && cd / \
  && rm -rf /unison-2.48.3 \
  && unison -version

RUN mkdir -p /root/.unison /root/.ssh
COPY ssh-config /root/.ssh/config
COPY *.prf /root/.unison/

# add utilities
COPY schedule.rb /schedule.rb
COPY schedule_root.rb /schedule_root.rb
COPY bin/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
COPY lib/* /usr/local/lib/
RUN /usr/local/bin/update_wp_config.sh

COPY msmtprc.ini /etc/php5/apache2/conf.d/
COPY msmtprc.ini /etc/php5/cli/conf.d/
COPY templates /templates

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/init.sh"]
