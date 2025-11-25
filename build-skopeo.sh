#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GO_DIR="$HOME/go/src/github.com/containers"

echo "WARNING: This script will run dnf and install repositories in ~/go/src/github.com/containers"
read -p "Do you want to continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Installation cancelled."
	exit 1
fi

# for development
if [ $# -eq 1 ]; then
	user="git@github.com:vraiti"
else
	user="https://github.com/vraiti"
fi

# skopeo prerequisites
sudo dnf install gpgme-devel libassuan-devel btrfs-progs-devel

if [ ! -d $GO_DIR ]; then
	mkdir -p $GO_DIR
fi

# make and build skopeo
mkdir -p $GO_DIR

cd $GO_DIR

git clone $user/skopeo.git skopeo
git clone $user/container-libs.git container-libs
git clone $user/tar-diff.git tar-diff

sh $SCRIPT_DIR/link-repos.sh

make -C skopeo bin/skopeo
