#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

PHPUNIT_DIR="$TRAVIS_BUILD_DIR/vendor/phpunit/phpunit/composer/bin/phpunit"


$PHPUNIT_DIR/phpunit --testdox --bootstrap vendor/autoload.php app/
