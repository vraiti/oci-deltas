#!/bin/bash

set -euo pipefail

if [ -z $1 ]; then
	echo "usage: $0 [repo for storing sample images]"
	exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sh $SCRIPT_DIR/build-skopeo.sh
sh $SCRIPT_DIR/build-containers.sh
sh $SCRIPT_DIR/pull-by-deltas.sh
