#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

# temporary solution: .travis.yml doesn't support it yet
#addons:
#  apt:
#    sources:
#      - heroku
#    packages:
#      - heroku-toolbelt
HEROKU_CLIENT_DIR="$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/heroku-client/bin"
HEROKU_CLIENT_URL="https://s3.amazonaws.com/assets.heroku.com/heroku-client/heroku-client.tgz"


#wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
mkdir -p "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR"
if [ ! -f "$HEROKU_CLIENT_DIR/heroku" ]; then
    curl -s $HEROKU_CLIENT_URL | tar xz

    mkdir -p "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/heroku-client"
    mv heroku-client/* "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/heroku-client"
    rmdir heroku-client
fi

echo -e "machine api.heroku.com\n  login git\n  password $HEROKU_AUTH_TOKEN" >> ~/.netrc
echo -e "machine git.heroku.com\n  login git\n  password $HEROKU_AUTH_TOKEN" >> ~/.netrc
chmod 0600 ~/.netrc
