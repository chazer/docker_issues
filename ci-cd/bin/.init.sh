#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$DIR/.functions.sh"
export PATH="$DIR:$PATH"


assert_git_exists
assert_docker_exists
assert_docker_compose_exists


PROJECT_ROOT="$(cd "$DIR/.." >/dev/null && pwd)"
PROJECT_NAME="${PROJECT_NAME:-example}"

VERSION_HASH="$( cd "$PROJECT_ROOT" && git_commit_hash )"
VERSION_NAME="${VERSION_NAME:-$( cd "$PROJECT_ROOT" && git_commit_tag )}"
VERSION_NAME="${VERSION_NAME:-$( cd "$PROJECT_ROOT" && git_branch_name | sed 's/\//_/g' )-$VERSION_HASH}"

if [ -f "$DIR/.env" ]; then
    source "$DIR/.env"
fi

echo PROJECT_ROOT=${PROJECT_ROOT}
echo PROJECT_NAME=${PROJECT_NAME}
echo VERSION_HASH=${VERSION_HASH}
echo VERSION_NAME=${VERSION_NAME}
