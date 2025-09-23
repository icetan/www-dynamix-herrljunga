#!/bin/bash
set -eo pipefail

(cd "${1:?Missing argument #1: repo path}"
  set -x
  nix develop . --command bash -c '
set -xe

INSTA_DIR=./instagram

git restore --source=HEAD --staged --worktree -- "$INSTA_DIR"
git clean -df "$INSTA_DIR"
git pull
./bin/mk-config.sh
./bin/update-instagram.sh
./bin/gen-posts.sh
git add "$INSTA_DIR"
if git commit -m "Created by bin/update-commit-push.sh from $(uname -n)"; then
  git push
fi
'
)
