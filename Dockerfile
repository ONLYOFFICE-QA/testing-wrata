FROM ruby:3.2.0-alpine

LABEL maintainer="shockwavenn@gmail.com"
# To fix Error: error:0308010C:digital envelope routines::unsupported
# More details at https://github.com/webpack/webpack/issues/14532#issuecomment-947012063
ENV NODE_OPTIONS="--openssl-legacy-provider"

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
