#!/usr/bin/env bash

# export GITHUB_TOKEN=<gh-token>

flux bootstrap github \
    --token-auth \
    --owner=bashfulrobot \
    --repository=clusters \
    --branch=main \
    --path=spitfire/workloads/flux \
    --personal
