FROM ruby:2.6.5-alpine
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base ruby-dev postgresql-dev git bash
RUN mkdir /espatifo_production
WORKDIR /espatifo_production

## Setting shell variables for rails production environment
ARG RAILS_ENV
ENV RAILS_ENV="production"
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=740f5b65155ca3804b0824983eb5d1a7

# Puma
ARG PORT
ENV PORT=3000
ARG WORKER_TIMEOUT
ENV WORKER_TIMEOUT=3600
ARG RAILS_MAX_THREADS
ENV RAILS_MAX_THREADS=2
ARG WEB_CONCURRENCY
ENV WEB_CONCURRENCY=2

# Porstgresql database
ARG DB_NAME
ENV DB_NAME=espatifo
ARG DB_USER
ENV DB_USER=postgres
ARG DB_HOST
ENV DB_HOST=db

# Redis
ARG REDIS_URL
ENV REDIS_URL=redis://redis:6379
ARG REDIS_CACHE_PATH
ENV REDIS_CACHE_PATH=0/cache

# Sidekiq
ARG SIDEKIQ_WORKER_URL
ENV SIDEKIQ_WORKER_URL=redis://redis:6379/1
ARG SIDEKIQ_QUEUE_PREFIX
ENV SIDEKIQ_QUEUE_PREFIX=espatifo:workers

COPY Gemfile /espatifo_production/Gemfile
COPY Gemfile.lock /espatifo_production/Gemfile.lock
RUN gem install bundler
RUN bundle install --jobs 4 --retry 3

# Remove build dependencies and install runtime dependencies
#RUN apk del build-dependency
RUN apk add --update postgresql-client postgresql-libs tzdata

COPY . /espatifo_production
RUN touch /tmp/caching-dev.txt

# Add a script to be executed every time the container starts#.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
#EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
