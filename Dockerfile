FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /time
WORKDIR /time
ADD . /time
RUN bundle install