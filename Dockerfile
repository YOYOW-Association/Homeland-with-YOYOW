# NAME:     yoyow/dposclub
FROM homeland/base:1.0.1
LABEL maintainer="yoyow.org"

ENV RAILS_ENV 'production'

ENV HOMELAND_VERSION 'master'

RUN useradd ruby -s /bin/bash -m -U &&\
    mkdir -p /var/www &&\
    cd /var/www
ADD . /var/www/dposclub
RUN cd /var/www/dposclub && bundle install --deployment &&\
    find /var/www/dposclub/vendor/bundle -name tmp -type d -exec rm -rf {} + &&\
    chown -R ruby:ruby /var/www

WORKDIR /var/www/dposclub
