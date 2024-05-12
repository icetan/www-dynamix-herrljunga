#!/usr/bin/env bash

set -xe
(cd instagram
  instaloader --fast-update dynamixherrljunga \
    --no-videos --no-metadata-json --no-compress-json \
    --no-resume --no-iphone --no-profile-pic
)
