FROM ruby:2.7.1

RUN apt-get update -qq && apt-get install -y vim less locales

RUN mkdir -p /app
RUN update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

WORKDIR /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

COPY src/Gemfile /app/Gemfile
COPY src/Gemfile.lock /app/Gemfile.lock

CMD ["rails", "server", "-b", "0.0.0.0"]
