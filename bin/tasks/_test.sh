#!/usr/bin/env bash
set -e

# skip this step if previous has failed
if [ "$TRAVIS_TEST_RESULT" = "1" ]; then
   exit;
fi
# add code BELOW this line

echo "current TRAVIS_TEST_RESULT: $TRAVIS_TEST_RESULT"
echo "-----------------------------"
echo "    new TRAVIS_TEST_RESULT: $2"

exit $2
