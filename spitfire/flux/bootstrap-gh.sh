#!/usr/bin/env bash

# https://www.youtube.com/watch?v=X5W_706-jSY

# (Bash)
# export GITHUB_TOKEN=<gh-token>
# (Fish)
# set -x GITHUB_TOKEN <gh-token>
# if not set, should prompt for the token
# if permissions error - check if the token exists

flux bootstrap github \
    --token-auth \
    --owner=bashfulrobot \
    --repository=clusters \
    --branch=main \
    --path=spitfire/flux \
    --personal
