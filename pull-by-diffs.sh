#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GO_DIR="$HOME/go/src/github.com/containers"

if [ $# -ne 1 ]; then
	echo "Usage: $0 [quay repo for test containers]"
fi

repo=$1

if [ -z $GO_DIR ]; then
	mkdir -p ~/go
fi

V1=$repo:foo-v1
V2=$repo:foo-v2
V3=$repo:foo-v3

skopeo=$GO_DIR/skopeo/bin/skopeo

# test delta-based pull
podman rmi $V1
podman rmi $V2
podman rmi $V3

$skopeo copy --debug docker://$V1 containers-storage:$V1
$skopeo copy --debug docker://$V3 containers-storage:$V3
$skopeo copy --debug docker://$V2 containers-storage:$V2

echo
echo "NOTE: Skopeo debug logs include information about blob and delta sizes"
echo "To see network usage, look for lines with \"(blob size: ...)\" or \"(delta size: ...)\""
