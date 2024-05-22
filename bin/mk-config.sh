#!/usr/bin/env bash

yq -s add _base_config.yml _prod_config.yml > _config.yml
