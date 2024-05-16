#!/usr/bin/env bash

PROFILE="dynamixherrljunga"
SESSION_PATH="$PWD/.sessionfile"

set -e
# base64 --decode <<<"$INSTALOADER_SESSION_BASE64" > "$SESSION_PATH"

(cd instagram
  instaloader \
    --login "$PROFILE" \
    -f <(base64 --decode <<<"$INSTALOADER_SESSION_BASE64") \
    "$PROFILE" \
    --fast-update \
    --no-videos --no-metadata-json --no-compress-json \
    --no-resume --no-iphone --no-profile-pic
    # -p "$INSTAGRAM_PASSWORD"
)
