FROM ruby:2.3.4-alpine

RUN apk update && apk upgrade && apk add --update --no-cache alpine-sdk tzdata sqlite-dev nodejs
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --path vendor/bundle -j4
ADD . /app
