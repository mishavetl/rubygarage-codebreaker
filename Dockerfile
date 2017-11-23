FROM ubuntu:16.04

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y ruby2.3 git && apt-get clean
RUN cd /app && gem install bundler && bundle install
