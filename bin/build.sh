#!/usr/bin/env bash

bundle install
yq -s add _base_config.yml _prod_config.yml > _config.yml
jekyll build
