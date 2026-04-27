#!/bin/bash

set -e

# Construct Moodle URL
if [ -n "$MOODLE_VERSION" ]; then
  MOODLE_URL="https://packaging.moodle.org/${MOODLE_VERSION}/moodle-latest-${MOODLE_VERSION#stable}.zip"
else
  MOODLE_URL=${MOODLE_URL}
fi

if [ ! -d moodle ]; then
  # Download and extract Moodle
  curl -o moodle.zip $MOODLE_URL
  unzip moodle.zip
  rm moodle.zip

  # Move config
  mv config-dist.php moodle/config.php

  # Install dependencies
  composer install --no-dev --classmap-authoritative --working-dir=moodle
  
  # Set permissions
  chown -R www-data:www-data moodle
fi

# Copy volume mounted config
if [ -f config.php ]; then
  cp config.php moodle/config.php

  # Set permissions
  chown www-data:www-data moodle/config.php
fi

# Copy volume mounted local plugins
if [ -d local ]; then
  mkdir -p moodle/public/local
  cp -a local/. moodle/public/local/

  # Set permissions
  chown -R www-data:www-data moodle/public/local
fi

# Ensure permissions for moodledata
chown -R www-data:www-data moodledata

exec "$@"
