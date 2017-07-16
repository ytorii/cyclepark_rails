FROM ruby:2.3.4-alpine

RUN apk update && apk upgrade && apk add --no-cache sqlite-dev nodejs alpine-sdk tzdata 
RUN mkdir -p /opt/phantomjs/2.11
ADD phantomjs /opt/phantomjs/2.11/phantomjs
RUN ln -s /opt/phantomjs/2.11/phantomjs /usr/bin/phantomjs && phantomjs --version
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --path vendor/bundle -j4
RUN bundle update poltergeist
ADD . /app
