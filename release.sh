#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

APP_NAME="Music Manager"
APP_FILE_NAME="music_manager.py"
APP_FILES="music_manager.py LICENSE README.md"
RELEASE_VERSION="${1}"
NEXT_VERSION="${2}-SNAPSHOT"
ZIP_FILENAME="${APP_NAME}-${RELEASE_VERSION}.zip"

echo "Changing version to ${RELEASE_VERSION}"
sed -E -i.releaseBackup "s/^__version__ = .*$/__version__ = '${RELEASE_VERSION}'/" ${APP_FILE_NAME}

echo "Committing changes"
git add ${APP_FILE_NAME}
git commit -m "Release ${RELEASE_VERSION}"

echo "Generating tag ${RELEASE_VERSION}"
git tag -a "${RELEASE_VERSION}" -m "Release ${RELEASE_VERSION}"

echo "Pushing changes"
git push --follow-tags

echo "Generating compressed archive ${ZIP_FILENAME}"
[ -f "${ZIP_FILENAME}" ] && rm "${ZIP_FILENAME}" 2>/dev/null
zip -r "${ZIP_FILENAME}" ${APP_FILES} -x "*__pycache__*"

echo "Changing version to ${NEXT_VERSION}"
sed -E -i "s/^__version__ = .*$/__version__ = '${NEXT_VERSION}'/" ${APP_FILE_NAME}

echo "Committing changes"
git add ${APP_FILE_NAME}
git commit -m "Bump version to ${NEXT_VERSION}"
git push
