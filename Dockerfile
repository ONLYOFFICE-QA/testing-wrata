FROM ruby:2.4.3

MAINTAINER Pavel.Lobashov "shockwavenn@gmail.com"

RUN apt-get update -qq && apt-get install -y libpq-dev nodejs
COPY ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/*

WORKDIR /tmp
COPY Gemfile* /tmp/
RUN bundle install

RUN mkdir /root/wrata
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle install
RUN RAILS_ENV=production rake assets:precompile
ENV RAILS_SERVE_STATIC_FILES=true
CMD rm -f /root/wrata/tmp/pids/server.pid && \
    RAILS_ENV=production rake db:create db:migrate db:seed && \
    SECRET_KEY_BASE=82bac4f58c93c32288273e15afe2b91b171d9d7eb7c17e7f4ce15d7839143caabf9c7093b8b09c84172a1fffb3c2a9cb30c5f38c81c4623364e3915596e5c8c2 \
    bundle exec rails s -p 3000 -b '0.0.0.0' --environment=production