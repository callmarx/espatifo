#!/bin/bash
exec dotenv bundle exec sidekiq -C config/sidekiq.yml.erb >> log/sidekiq.log
