#!/bin/bash
set -eo pipefail

(cd "${1:?Missing argument #1: repo path}"
  set -x
  nix develop . --command bash -c '
set -xe
git pull
./bin/mk-config.sh
./bin/update-instagram.sh
./bin/gen-posts.sh
git add ./instagram
if git commit -m "Created by bin/update-commit-push.sh from $(uname -n)"; then
  git push
fi
'
)
