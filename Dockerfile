FROM ruby:3.1.3-alpine

LABEL maintainer="shockwavenn@gmail.com"

RUN apk add --no-cache build-base \
                       gcompat \
                       git \
                       nodejs \
                       openssh-client \
                       postgresql-dev \
                       sshpass \
                       tzdata \
                       yarn
WORKDIR /tmp
COPY Gemfile* /tmp/
RUN gem install bundler
RUN bundle config set without 'development' && \
    bundle install

RUN mkdir /root/wrata
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle install && \
    yarn install
RUN rake assets:precompile
ENV RAILS_SERVE_STATIC_FILES=true
CMD ["sh", "entrypoint.sh"]
