FROM ruby:2.3.4-alpine

RUN sed -i -e 's/v3\.4/edge/g' /etc/apk/repositories
RUN apk update && apk upgrade && apk add --update --no-cache sqlite-dev nodejs alpine-sdk tzdata udev ttf-freefont 'chromium>59.0' 'chromium-chromedriver>59.0'

RUN mkdir /noto
ADD NotoSansCJKjp-hinted.zip /noto 
WORKDIR /noto
RUN unzip NotoSansCJKjp-hinted.zip && \
    mkdir -p /usr/share/fonts/noto && \
    cp *.otf /usr/share/fonts/noto && \
    chmod 644 -R /usr/share/fonts/noto/ && \
    fc-cache -fv
WORKDIR /
RUN rm -rf /noto

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN apk add --no-cache --virtual build-dependencies build-base && \
    apk add --no-cache libxml2-dev libxslt-dev && \
    gem install nokogiri -- --use-system-libraries \
    --with-xml2-config=/usr/bin/xml2-config \
    --with-xslt-config=/usr/bin/xslt-config && \
    apk del build-dependencies
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install --path vendor/bundle -j4
ADD . /app
