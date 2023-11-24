FROM ruby:3.2.2-alpine

LABEL maintainer="shockwavenn@gmail.com"
# To fix Error: error:0308010C:digital envelope routines::unsupported
# More details at https://github.com/webpack/webpack/issues/14532#issuecomment-947012063
ENV NODE_OPTIONS="--openssl-legacy-provider"
ENV RAILS_SERVE_STATIC_FILES=true

RUN apk add --no-cache build-base \
                       gcompat \
                       git \
                       nodejs \
                       openssh-client \
                       postgresql-dev \
                       sshpass \
                       tzdata \
                       yarn
WORKDIR /root/wrata
COPY . /root/wrata
RUN gem install bundler && \
    bundle config set without 'development test' && \
    bundle install && \
    yarn install
RUN rake assets:precompile
CMD ["sh", "entrypoint.sh"]
