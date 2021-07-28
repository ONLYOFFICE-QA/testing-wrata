FROM ruby:3.0.2-alpine

LABEL maintainer="shockwavenn@gmail.com"

RUN apk add --no-cache build-base \
                       nodejs \
                       openssh-client \
                       postgresql-dev \
                       sshpass \
                       tzdata
WORKDIR /tmp
COPY Gemfile* /tmp/
RUN gem install bundler
RUN bundle config set without 'development' && \
    bundle install

RUN mkdir /root/wrata
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle install
RUN rake assets:precompile
ENV RAILS_SERVE_STATIC_FILES=true
CMD rm -f /root/wrata/tmp/pids/server.pid && \
    RAILS_ENV=production rake db:create db:migrate db:seed && \
    bundle exec rails s -p 3000 -b '0.0.0.0' --environment=production