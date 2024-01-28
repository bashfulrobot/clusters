## PAT Creation (Fine Grained)

Ok, under "repository permissions" you need each of the following:

Administration: `read/write`

Contents: `read/write`

Metadata (mandatory): `read-only`

export GITHUB_TOKEN=<your-token>
export GITHUB_TOKEN=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

export GITHUB_USER=<your-username>
export GITHUB_USER=bashfulrobot

flux check --pre

flux bootstrap github --owner=$GITHUB_USER --repository=clusters --branch=main path=./spitfire/flux --personal

  `--path` is relative to the repo root.
