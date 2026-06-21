#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Run migrations and seeds
bundle exec rails db:prepare
bundle exec rails db:seed
