#!/usr/bin/env bash
set -xe
SRC_DIR=instagram/dynamixherrljunga
POST_DIR="$SRC_DIR/_posts"
CFG_BASEURL=$(yq -r .baseurl _config.yml)

mapfile -t txt_files < <(find "$SRC_DIR" -name "*.txt")

mkdir -p "$POST_DIR"
for txt in "${txt_files[@]}"; do
  base_name=$(basename "$txt" .txt)
  date_=$(cut -d_ -f1 <<<"$base_name")
  time_=$(cut -d_ -f2 <<<"$base_name" | tr - :)
  post_file="$POST_DIR/$date_-$(echo "$time_" | tr : -).markdown"
  mapfile -t image_files < <(find "$SRC_DIR" -name "${base_name}*.jpg")
  post_text=$(cat "$txt")
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
---
$(echo "$post_text" | sed \
  -e 's,#\([^\t ][^\t ]*\),[#\1](https://www.instagram.com/explore/tags/\1/),g' \
  -e 's,\(^\| \)@\([^\t ][^\t ]*\),\1[@\2](https://www.instagram.com/\2/),g'
)

$(for img in "${image_files[@]}"; do
    echo
    echo
    echo "<img src='$CFG_BASEURL/$img' class='img-fluid' />"
  done)
EOF
done
