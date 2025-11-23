# OCI Deltas

This repository gives a quick demo of the capabilities of the tar-diff OCI delta patch proposed in the corresponding `container-libs` repository pull request.
* `setup.sh` installs and builds the patched Skopeo into `$GOBIN/src/github.com/containers`. Will also clone patched dependencies
* `build-containers.sh [REPO]` builds, pushes, and computes a delta between two images that differ by a single-byte edit to a 1 GB file of random data
* `test-skopeo.sh [REPO]` invokes the patched Skopeo to pull the two images, with logs to indicate the difference in network performance in this idealized scenario
