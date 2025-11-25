#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GO_DIR="$HOME/go/src/github.com/containers"

if [ $# -ne 1 ]; then
	echo "Usage: $0 [quay repo for test containers]"
	exit 1
fi

repo=$1

if [ -z $GO_DIR ]; then
	mkdir -p ~/go
fi

# make containers
cd $SCRIPT_DIR


V1=$repo:foo-v1
V2=$repo:foo-v2
V3=$repo:foo-v3

# skopeo will only try to generate deltas between layers of matching index, so we
# squash the images to just generate a delta from one entire image to another
podman build --squash-all --format oci . -t $V1 -f Containerfile.v1
podman build --squash-all --format oci . -t $V2 -f Containerfile.edit --build-arg BASE_IMAGE=$V1 --build-arg LINE=0
podman build --squash-all --format oci . -t $V3 -f Containerfile.edit --build-arg BASE_IMAGE=$V2 --build-arg LINE=1

podman push $V1
podman push $V2
podman push $V3

skopeo=$GO_DIR/skopeo/bin/skopeo

# generate container delta
# syntax is generate-delta [TO] [FROM]
$skopeo generate-delta --fallback-config-type --fallback-layer-type docker://$V2 docker://$V1
$skopeo generate-delta --fallback-config-type --fallback-layer-type docker://$V3 docker://$V2
$skopeo generate-delta --fallback-config-type --fallback-layer-type docker://$V3 docker://$V1
