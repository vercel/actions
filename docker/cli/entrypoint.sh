#!/bin/sh -l

set -eo pipefail

sh -c "docker $*"
