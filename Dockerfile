FROM ruby:3.4.1-alpine AS builder

LABEL maintainer="shockwavenn@gmail.com"
# To fix Error: error:0308010C:digital envelope routines::unsupported
# More details at https://github.com/webpack/webpack/issues/14532#issuecomment-947012063
ENV NODE_OPTIONS="--openssl-legacy-provider"

RUN apk add --no-cache build-base \
                       gcompat \
                       nodejs \
                       postgresql-dev \
                       tzdata \
                       yarn
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle config set without 'development test' && \
    bundle install && \
    yarn install
RUN rake assets:precompile

FROM ruby:3.4.1-alpine
ENV RAILS_SERVE_STATIC_FILES=true
RUN apk add --no-cache git \
                       libpq \
                       nodejs \
                       openssh-client \
                       sshpass \
                       tzdata
COPY . /root/wrata
WORKDIR /root/wrata
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /root/wrata/public /root/wrata/public
CMD ["sh", "entrypoint.sh"]
