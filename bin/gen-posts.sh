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
  cat > "$post_file" <<EOF
---
layout: post
title: |
  $(cat "$txt" | grep -o '^[^.,!?]*' | head -n1)
date:   $date_ $time_ +0000
categories: instagram
image: /${image_files[0]}
background: /${image_files[0]}
thumbnail: /${image_files[0]}
---
$(cat "$txt")

$(for img in "${image_files[@]}"; do
    echo
    echo
    echo "<img src='$CFG_BASEURL/$img' class='img-fluid' />"
  done)
EOF
done
