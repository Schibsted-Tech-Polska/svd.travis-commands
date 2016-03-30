#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

PHPCSFIXER_DIR="$TRAVIS_BUILD_DIR/vendor/fabpot/php-cs-fixer"


$PHPCSFIXER_DIR/php-cs-fixer --dry-run --verbose fix
