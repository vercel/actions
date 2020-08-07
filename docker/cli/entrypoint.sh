#!/bin/sh -l
set -x
env | sort

set -eo pipefail

if [ "$1" = "build" ]; then

    test -z "$PROJECT_PATH" && {
            echo "no PROJECT_PATH provided" >&2
            exit 1
    }

    # Check if it's a tag
    case "$GITHUB_REF" in 
        refs/tags/*)
            TAG=$(echo "$GITHUB_REF" | cut -f3 -d'/')
            ;;
    esac


    # If there is a tag, use the tag
    if [ -n "$TAG" ]; then
        # Try to get the previous tag. If first one, return same
        PREVIOUS_REF="$(git describe --tags --abbrev=0 "tags/$TAG^" || echo $TAG)"
    elif [ -n "$GITHUB_BASE_REF" ]; then
        # In a pull request, GitHub provides the base branch (usually "master")
        PREVIOUS_REF="$GITHUB_BASE_REF"
    else
        # Fallback to using the previous commit as REF
        PREVIOUS_REF="$(git rev-parse HEAD^1)"
    fi


    should_build() {
            # Setting SHOULD_BUILD=1 allows enforcing a build
            test -z "$SHOULD_BUILD" || {
                echo "build enforced by SHOULD_BUILD"
                return 0
            }

            # --quiet will exit 1 if there are differences and 0 if none.
            # should deploy if lambda was changed
            git diff --quiet HEAD "$PREVIOUS_REF" -- "$PROJECT_PATH" || return 0

            # Otherwise do not deploy.
            return 1
    }

    # Exit successfully if nothing to build
    should_build || {
        echo "$PROJECT_PATH hasn't changed since last commit or release $PREVIOUS_REF. Setting build skipped flag"
        echo ::set-output name=build_skipped::true

        exit 0
    }

fi


sh -c "docker $*"
