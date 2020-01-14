FROM ruby:2.6.5-alpine
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev postgresql-dev git bash less
RUN mkdir /espatifo_development
WORKDIR /espatifo_development
COPY Gemfile /espatifo_development/Gemfile
COPY Gemfile.lock /espatifo_development/Gemfile.lock
RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

RUN apk add --update postgresql-client postgresql-libs tzdata
COPY . /espatifo_development
RUN touch /tmp/caching-dev.txt

# Add a script to be executed every time the container starts#.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#EXPOSE 3000

# Start the main process.
#CMD ["bundle", "exec", "sidekiq", "&>", "log/sidekiq.log"]
#CMD ["rm", "-f", "tmp/pids/server.pid"]
#CMD ["rails", "server", "-b", "0.0.0.0"]
