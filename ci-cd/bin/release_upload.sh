#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source "$DIR/.init.sh"

IMAGE_PREFIX=${IMAGE_PREFIX:-$PROJECT_NAME}
DEPLOY_SSH=${DEPLOY_SSH:-}

if [ -z "$DEPLOY_SSH" ]; then
    echo "The DEPLOY_SSH variable is empty. You should export it or setup value in bin/.env file">&2
    exit 1
fi

compose() {
    export BUILD_HASH=${VERSION_HASH}
    export BUILD_VERSION=${VERSION_NAME}
    docker-compose \
        --project-directory "$PROJECT_ROOT" \
        --project-name "$PROJECT_NAME" \
        --env-file "$PROJECT_ROOT/docker/.env" \
        --file "$PROJECT_ROOT/docker/docker-compose.release.yml" \
        "$@"
}

size_image() {
    docker save "$1" | wc -c
}

upload_image() {
    local registry="$DOCKER_REGISTRY"
    local image="$1"
    if [ "$registry" ]; then
        echo "upload image $1 via $registry to host $2">&2 \
        && docker tag ${image} ${registry}/${image} \
        && docker push ${registry}/${image} \
        && ssh "$2" docker pull  ${registry}/${image} \
        && ssh "$2" docker tag ${registry}/${image} ${image} \
        && ssh "$2" docker image rm ${registry}/${image} \
        && docker image rm ${registry}/${image} || return 1
    else
        echo "upload image $1 directly to host $2">&2 \
        docker save "$1" | ssh "$2" docker load
    fi
}

echo > "$PROJECT_ROOT/docker/.env"
echo "BUILD_HASH=${VERSION_HASH}" >> "$PROJECT_ROOT/docker/.env"
echo "BUILD_VERSION=${VERSION_NAME}" >> "$PROJECT_ROOT/docker/.env"
echo "PROJECT_NAME=${PROJECT_NAME}" >> "$PROJECT_ROOT/docker/.env"
echo "IMAGE_TAG=${VERSION_NAME}" >> "$PROJECT_ROOT/docker/.env"

compose build --parallel || exit 1

upload_image ${IMAGE_PREFIX}_router:${VERSION_NAME} ${DEPLOY_SSH}
upload_image ${IMAGE_PREFIX}_php_backend:${VERSION_NAME} ${DEPLOY_SSH}
upload_image ${IMAGE_PREFIX}_python_backend:${VERSION_NAME} ${DEPLOY_SSH}
