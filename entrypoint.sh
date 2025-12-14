#!/bin/bash

set -e

# Construct Moodle URL
if [ -n "$MOODLE_VERSION" ]; then
  MOODLE_URL="https://packaging.moodle.org/${MOODLE_VERSION}/moodle-latest-${MOODLE_VERSION#stable}.zip"
else
  MOODLE_URL=${MOODLE_URL}
fi

if [ ! -d /var/www/html/moodle ]; then
  curl -o moodle.zip $MOODLE_URL
  unzip moodle.zip
  cd moodle
  composer install --no-dev --classmap-authoritative
  chown -R www-data:www-data /var/www/html
fi

# Ensure permissions for moodledata
chown -R www-data:www-data /var/www/html/moodledata

exec "$@"