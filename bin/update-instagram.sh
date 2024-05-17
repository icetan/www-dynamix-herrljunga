#!/usr/bin/env bash
set -e

args=()

while [[ $1 ]]; do
  case $1 in
    --no-fast|-n) no_fast=1;;
    --debug|-d) set -x;;
    -*) echo >&2 "No option: $1"; exit 1;;
    *) INSTA_PROFILE="$1";;
  esac
  shift
done

[[ $no_fast ]] || args+=(--fast-update)

INSTA_PROFILE="${INSTA_PROFILE:-dynamixherrljunga}"
INSTALOADER_SESSION_BASE64="${INSTALOADER_SESSION_BASE64:?Need to set session key as base64 string, use bin/get-instaloader-session}"

(cd instagram
  instaloader \
    --login "$INSTA_PROFILE" \
    -f <(base64 --decode <<<"$INSTALOADER_SESSION_BASE64") \
    "$INSTA_PROFILE" \
    --no-videos --no-resume --no-iphone --no-profile-pic \
    "${args[@]}" \
    # --no-metadata-json --no-compress-json  \
    # -p "$INSTAGRAM_PASSWORD"
)
