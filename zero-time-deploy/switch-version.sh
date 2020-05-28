#/usr/bin/env bash

NEW_VERSION=$1

if [ -z "$NEW_VERSION" ]; then
    echo "No version provided">&2
    exit 1
fi

source .env


pause() {
    echo "pause $1 seconds">&2
    sleep $1
}

echo "Up version $NEW_VERSION, prev is $VERSION">&2


TMP_PROJECT="tmp_$(openssl rand -hex 2)"
TMP_ENV_FILE="$(mktemp)"

echo "Start new temp project">&2
cat .env > ${TMP_ENV_FILE}
echo "VERSION=$NEW_VERSION" >> ${TMP_ENV_FILE}
docker-compose --project-name=${TMP_PROJECT} --env-file=${TMP_ENV_FILE} up -d || exit 1

pause 30

echo "Start new project">&2
echo "VERSION=$NEW_VERSION" >> .env
docker-compose up -d || exit 1

pause 30

echo "Stop and remove temp project">&2
docker-compose --project-name=${TMP_PROJECT} --env-file=${TMP_ENV_FILE} down -v || exit 1
rm ${TMP_ENV_FILE} || true
