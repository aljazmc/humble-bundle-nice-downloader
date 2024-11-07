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

  docker compose run --rm node sh -c "printenv"

}

start() {

  node

}

"$1"
