# OCI Deltas

This repository gives a quick demo of the capabilities of the tar-diff OCI delta patch proposed in the corresponding `container-libs` repository pull request. To run, simply execute `run.sh`

WARNING: this will install repositories in `~/go`

`run-all.sh [REPO]` will simply run the following scripts in sequence:
* `build-skopeo.sh` installs and builds the patched Skopeo into `$GOBIN/src/github.com/containers`. Will also clone patched dependencies
* `build-containers.sh [REPO]` builds a Fedora image that contains a single file of just "foo" repeated for some 1.1 GB. It then builds two "edits" of that container that modify a single character in this data file. It then pushes them and computes the layer delta.
* `pull-by-deltas.sh [REPO]` invokes the patched Skopeo to pull the three images, with logs to indicate the difference in network performance in this idealized scenario
