#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GO_DIR="$HOME/go/src/github.com/containers"

cd $GO_DIR

# replace libraries in vendor with patched versions
# for skopeo
PODMAN_LIBS=$GO_DIR/skopeo/vendor/go.podman.io
rm -r $PODMAN_LIBS/storage
ln -s $GO_DIR/container-libs/storage $PODMAN_LIBS/storage

rm -r $PODMAN_LIBS/common
ln -s $GO_DIR/container-libs/common $PODMAN_LIBS/common

rm -r $PODMAN_LIBS/image/v5
ln -s $GO_DIR/container-libs/image $PODMAN_LIBS/image/v5

# for container-libs
CONTAINER_LIBS=$GO_DIR/skopeo/vendor/github.com/containers
rm -r $CONTAINER_LIBS/tar-diff
ln -s $GO_DIR/tar-diff $CONTAINER_LIBS/tar-diff
