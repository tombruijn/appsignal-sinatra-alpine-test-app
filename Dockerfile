ARG ruby_version=3.2
ARG os_version=alpine

FROM ruby:${ruby_version}-${os_version} AS dist

RUN apk upgrade --available --no-cache \
    && apk add --no-cache \
      bash \
      gcompat \
      imagemagick \
      ghostscript \
      libpq \
      tzdata \
      alpine-sdk \
      coreutils

ARG uid=10001 gid=10001

ENV PORT=8080 \
    PATH=/opt/app/bin:/opt/bin:${PATH} \
    PIDFILE=/tmp/puma-server.pid \
    APPSIGNAL_APP_ENV=development \
    RAILS_ENV=development \
    RACK_ENV=development \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    APPSIGNAL_PUSH_API_KEY="PUSH-API-KEY" \
    APPSIGNAL_APP_NAME="ruby-sinatra-alpine" \
    APPSIGNAL_WORKING_DIRECTORY_PATH="/tmp/appsignal/" \
    APPSIGNAL_LOG_PATH="/tmp" \
    APPSIGNAL_LOG_LEVEL="debug" \
    APPSIGNAL_HOSTNAME="test-setup-container"

RUN mkdir /opt/bin

RUN addgroup -S -g ${gid} app \
    && adduser -D -s /bin/bash -u ${uid} -G app app

WORKDIR /opt/app

COPY app /opt/app
RUN chgrp -R app /opt/app

# We only need one tmp dir. Link ./tmp to /tmp
RUN rm -rf tmp && ln -sf /tmp tmp

RUN mkdir -p tmp/appsignal

RUN bundle config set path /tmp/vendor/bundle
RUN bundle install

USER app

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
