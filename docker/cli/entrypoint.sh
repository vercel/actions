#!/bin/sh -l


set -exo pipefail

if [ "$1" = "build" ]; then

    eval DIR=\${$#}

    TAG=$(echo "$GITHUB_REF" | cut -f3 -d'/')

    # By default use previous commit as REF
    PREVIOUS_REF=$(git rev-parse HEAD^1)

    # IF there is a tag, use the tag
    if [ -n "$TAG" ]; then
        # tries to get the previous tag. If first one, return same
        PREVIOUS_REF="$(git describe --tags --abbrev=0 "tags/$TAG^" || echo $TAG)"

    fi


    should_build() {
            # --quiet will exit 1 if there are differences and 0 if none.
            # should deploy if lambda was changed
            git diff --quiet HEAD "$PREVIOUS_REF" -- "$DIR" || return 0

            # otherwise do not deploy.
            return 1
    }

    # Exit successfully if nothing to build
    should_build || {
        echo "$DIR hasn't changed since last commit or release $PREVIOUS_REF. Building dummy image instead"
        DIR=$(mktemp -d)
        echo -e "FROM scratch\nCMD foobar" > ${DIR}/Dockerfile
        # Replacing last positional parameter with dummy dir
        set -- ${@% *} $DIR

    }

fi


sh -c "docker $*"
