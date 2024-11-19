#!/bin/bash

## Variables

#PROJECT_NAME=`echo ${PWD##*/}` ## PROJECT_NAME = parent directory
PROJECT_UID=$(id -u)
PROJECT_GID=$(id -g)

## Configuration files

# docker-compose.yml
if [ ! -f docker-compose.yml ]; then
    cat << EOF > docker-compose.yml
services:
  node:
    image: node:current-alpine
    working_dir: /home/node
    volumes:
      - .:/home/node
    environment:
      NODE_ENV: development
      PATH: "/home/node/.yarn/bin:/home/node/node_modules/.bin:\$PATH"
    network_mode: host
EOF

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Adding user configuration line to docker-compose.yml for GNU/Linux users."
    sed -i "3 a \ \ \ \ user\:\ $PROJECT_UID\:$PROJECT_GID" docker-compose.yml
  fi

fi

clean() {

  docker compose down -v --rmi all --remove-orphans
    rm -rf \
    coverage \
    docker-compose.yml \
    firefox/fd2r40gx.firefox-testing-profile/AlternateServices.bin \
    firefox/fd2r40gx.firefox-testing-profile/SiteSecurityServiceState.bin \
    firefox/fd2r40gx.firefox-testing-profile/activity-stream.discovery_stream.json \
    firefox/fd2r40gx.firefox-testing-profile/activity-stream.weather_feed.json \
    firefox/fd2r40gx.firefox-testing-profile/addonStartup.json.lz4 \
    firefox/fd2r40gx.firefox-testing-profile/addons.json \
    firefox/fd2r40gx.firefox-testing-profile/bounce-tracking-protection.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/cache2 \
    firefox/fd2r40gx.firefox-testing-profile/cert9.db \
    firefox/fd2r40gx.firefox-testing-profile/compatibility.ini \
    firefox/fd2r40gx.firefox-testing-profile/containers.json \
    firefox/fd2r40gx.firefox-testing-profile/content-prefs.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/cookies.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/cookies.sqlite-wal \
    firefox/fd2r40gx.firefox-testing-profile/crashes \
    firefox/fd2r40gx.firefox-testing-profile/datareporting \
    firefox/fd2r40gx.firefox-testing-profile/extension-preferences.json \
    firefox/fd2r40gx.firefox-testing-profile/extensions.json \
    firefox/fd2r40gx.firefox-testing-profile/favicons.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/favicons.sqlite-wal \
    firefox/fd2r40gx.firefox-testing-profile/features \
    firefox/fd2r40gx.firefox-testing-profile/formhistory.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/gmp-gmpopenh264 \
    firefox/fd2r40gx.firefox-testing-profile/handlers.json \
    firefox/fd2r40gx.firefox-testing-profile/key4.db \
    firefox/fd2r40gx.firefox-testing-profile/lock \
    firefox/fd2r40gx.firefox-testing-profile/permissions.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/pkcs11.txt \
    firefox/fd2r40gx.firefox-testing-profile/places.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/places.sqlite-wal \
    firefox/fd2r40gx.firefox-testing-profile/prefs.js \
    firefox/fd2r40gx.firefox-testing-profile/protections.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/safebrowsing \
    firefox/fd2r40gx.firefox-testing-profile/search.json.mozlz4 \
    firefox/fd2r40gx.firefox-testing-profile/sessionCheckpoints.json \
    firefox/fd2r40gx.firefox-testing-profile/sessionstore.jsonlz4 \
    firefox/fd2r40gx.firefox-testing-profile/settings \
    firefox/fd2r40gx.firefox-testing-profile/shield-preference-experiments.json \
    firefox/fd2r40gx.firefox-testing-profile/startupCache \
    firefox/fd2r40gx.firefox-testing-profile/storage \
    firefox/fd2r40gx.firefox-testing-profile/storage.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/webappsstore.sqlite \
    firefox/fd2r40gx.firefox-testing-profile/webappsstore.sqlite-wal \
    firefox/fd2r40gx.firefox-testing-profile/xulstore.json \
    firefox/fd2r40gx.firefox-testing-profile/.parentlock \
    firefox/fd2r40gx.firefox-testing-profile/bookmarkbackups \
    firefox/fd2r40gx.firefox-testing-profile/broadcast-listeners.json \
    firefox/fd2r40gx.firefox-testing-profile/extension-store \
    firefox/fd2r40gx.firefox-testing-profile/extension-store-menus \
    firefox/fd2r40gx.firefox-testing-profile/extensions \
    firefox/fd2r40gx.firefox-testing-profile/minidumps \
    firefox/fd2r40gx.firefox-testing-profile/security_state \
    firefox/fd2r40gx.firefox-testing-profile/serviceworker.txt \
    firefox/fd2r40gx.firefox-testing-profile/sessionstore-backups \
    firefox/fd2r40gx.firefox-testing-profile/thumbnails \
    humble-bundle-nice-downloader \
    node_modules \
    yarn.lock \
    .cache \
    .config \
    .npm \
    .yarn/berry \
    .yarn/bin \
    .yarn/sdks \
    .yarn/unplugged \
    .yarn/install-state.gz \
    .yarnrc \
    .vim

}

node() {

if [ ! -f package.json ]; then
  docker compose run --rm node yarn init
else
  docker compose run --rm node yarn install
fi

  docker compose run --rm node yarn sdks
  docker compose run --rm node sh -c "printenv"

if [[ "$XDG_CURRENT_DESKTOP" == "MATE" ]]; then
  mate-terminal -- sh -c "docker compose run --rm node yarn build-watch"
  mate-terminal -- sh -c "docker compose run --rm node yarn test-watch"
  mate-terminal -- sh -c "docker compose run --rm node yarn typecheck-watch"
  mate-terminal -- sh -c "sleep 3 && ./ziphelper.sh"
  sleep 5
  firefox-esr --profile firefox/fd2r40gx.firefox-testing-profile/
fi

}

start() {

  node

}

"$1"
