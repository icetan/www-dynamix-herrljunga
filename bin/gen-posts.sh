#!/usr/bin/env bash
set -e

while [[ $1 ]]; do
  case $1 in
    --no-fast|-n) regen=1;;
    --debug|-d) set -x;;
    -*) echo >&2 "No option: $1"; exit 1;;
    *) INSTA_PROFILE="$1";;
  esac
  shift
done

INSTA_PROFILE="${INSTA_PROFILE:-$(yq -r .instagram_username _config.yml)}"
INSTA_PROFILE="${INSTA_PROFILE:-dynamixherrljunga}"

echo >&2 "Generating posts for instagram profile: $INSTA_PROFILE"

SRC_DIR=instagram/"$INSTA_PROFILE"
POST_DIR="$SRC_DIR/_posts"

mapfile -t txt_files < <(find "$SRC_DIR" -name "*.txt" | LC_ALL=C sort -r)

mkdir -p "$POST_DIR"
for txt in "${txt_files[@]}"; do
  base_name=$(basename "$txt" .txt)
  date_=$(cut -d_ -f1 <<<"$base_name")
  time_=$(cut -d_ -f2 <<<"$base_name" | tr - :)
  post_file="$POST_DIR/$date_-$(echo "$time_" | tr : -).markdown"

  if [[ ! "$regen" && -f "$post_file" ]]; then
    echo >&2 "Stopping early, post '$post_file' already exists"
    break
  fi

  extra_matter=""
  insta_shortcode=$(jq -r .node.shortcode "$SRC_DIR/$base_name.json" || true)
  if [[ "$insta_shortcode" ]]; then
    extra_matter+="
instagram_url: https://www.instagram.com/$INSTA_PROFILE/p/$insta_shortcode"
  fi

  mapfile -t image_files < <(find "$SRC_DIR" -name "${base_name}*.jpg")
  post_text=$(cat "$txt")

  echo >&2 "Creating post: $post_file"

  cat > "$post_file" <<EOF
---
layout: post
title: |
  $(echo "$post_text" | grep -o '^[^.,!?#]*' | head -n1)
excerpt: |
$(echo "$post_text" | sed -e 's,#[^\t ][^\t ]*,,g' -e 's,^,  ,')
date:   $date_ $time_ +0000
categories: instagram
background: /${image_files[0]}
thumbnail: /${image_files[0]}
$extra_matter
---
$(echo "$post_text" | sed \
  -e 's,#\([^\t ][^\t ]*\),[#\1](https://www.instagram.com/explore/tags/\1/),g' \
  -e 's,\(^\| \)@\([^\t ][^\t ]*\),\1[@\2](https://www.instagram.com/\2/),g'
)

$(for img in "${image_files[@]}"; do
    echo
    echo
    echo "<img src='{{ '/$img' | prepend: site.baseurl | replace: '//', '/' }}' class='img-fluid' />"
  done)
EOF
done
