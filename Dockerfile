FROM ruby:2.4.1

MAINTAINER Pavel.Lobashov "shockwavenn@gmail.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
COPY ssh/ /root/.ssh/
RUN chmod 600 /root/.ssh/*; ssh-keyscan github.com > /root/.ssh/known_hosts
RUN mkdir -pv /root/.do && echo "393d5ed4c6182f2e77091ef00d25455a4a9e44440c06c80c7b02df08a6e4aaec" > /root/.do/access_token
RUN mkdir ~/RubymineProjects
RUN git config --global user.email "teamlab.ruby@gmail.com" && \
    git config --global user.name "OnlyOffice Wrata"
RUN mkdir /root/wrata
WORKDIR /root/wrata
COPY . /root/wrata
RUN bundle install
CMD rm -f /root/wrata/tmp/pids/server.pid && \
    RAILS_ENV=production rake db:create db:migrate && \
    SECRET_KEY_BASE=82bac4f58c93c32288273e15afe2b91b171d9d7eb7c17e7f4ce15d7839143caabf9c7093b8b09c84172a1fffb3c2a9cb30c5f38c81c4623364e3915596e5c8c2 \
    bundle exec rails s -p 3000 -b '0.0.0.0' --environment=production