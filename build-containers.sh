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


V1=$repo:random-v1
V2=$repo:random-v2

# skopeo will only try to generate deltas between layers of matching index, so we
# squash the images to just generate a delta from one entire image to another
podman build --squash-all --format oci . -t $V1 -f Containerfile.v1
podman build --squash-all --format oci . -t $V2 -f Containerfile.v2 --build-arg BASE_IMAGE=$V1

podman push $V1
podman push $V2

skopeo=$GO_DIR/skopeo/bin/skopeo

# generate container delta
# syntax is generate-delta [TO] [FROM]
$skopeo generate-delta --fallback-config-type --fallback-layer-type docker://$V2 docker://$V1


# test delta-based pull
podman rmi $V1
podman rmi $V2

$skopeo copy --debug docker://$V1 containers-storage:$V1
$skopeo copy --debug docker://$V2 containers-storage:$V2

echo
echo "NOTE: Skopeo debug logs include information about blob and delta sizes"
echo "To see improvement, look for lines with \"(blob size: ...)\" or \"(delta size: ...)\""
