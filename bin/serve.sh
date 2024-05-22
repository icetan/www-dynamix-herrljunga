#!/usr/bin/env bash

bundle install
cp _base_config.yml _config.yml
jekyll serve
