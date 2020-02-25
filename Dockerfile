FROM ruby:2.7.0

MAINTAINER Pavel.Lobashov "shockwavenn@gmail.com"

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y libpq-dev \
                                             nodejs \
                                             sshpass
WORKDIR /tmp
COPY Gemfile* /tmp/
RUN gem install bundler
RUN bundle install

RUN mkdir /root/wrata
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle install
RUN rake assets:precompile
ENV RAILS_SERVE_STATIC_FILES=true
CMD rm -f /root/wrata/tmp/pids/server.pid && \
    RAILS_ENV=production rake db:create db:migrate db:seed && \
    bundle exec rails s -p 3000 -b '0.0.0.0' --environment=production