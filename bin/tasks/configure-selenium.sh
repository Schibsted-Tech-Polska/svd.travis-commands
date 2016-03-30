#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

SELENIUM_SERVER_DIR="$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/selenium-server/bin"
SELENIUM_SERVER_URL="http://selenium-release.storage.googleapis.com/2.52/selenium-server-standalone-2.52.0.jar"


#wget http://selenium-release.storage.googleapis.com/2.52/selenium-server-standalone-2.52.0.jar
mkdir -p "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR"
if [ ! -f "$SELENIUM_SERVER_DIR/selenium-server-standalone.jar" ]; then
    curl -s $SELENIUM_SERVER_URL -o selenium-server-standalone.jar

    mkdir -p "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/selenium-server/bin"
    mv selenium-server-standalone.jar "$TRAVIS_BUILD_DIR/$TRAVIS_CACHE_DIR/selenium-server/bin"
fi

java -jar $SELENIUM_SERVER_DIR/selenium-server-standalone.jar > /dev/null &
sleep 5
