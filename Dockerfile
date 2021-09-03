FROM ruby:3.0.2-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      less

ENV BUNDLE_JOBS=4 \
    LANG=ja_JP.UTF-8 \
    PAGER=less \
    TZ=Asia/Tokyo

WORKDIR /app
