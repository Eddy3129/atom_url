#!/usr/bin/env bash
set -o errexit  # exit on error

yarn install
bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

bundle exec rails db:migrate